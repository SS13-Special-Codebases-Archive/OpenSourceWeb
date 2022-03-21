using ByondSharp.FFI;
using ByondSharp.Util;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ByondSharp.Deferred
{
    /// <summary>
    /// Flags for timers from /tg/station codebase
    /// </summary>
    [Flags]
    public enum TimerFlag
    {
        Unique          = (1 << 0),
        Override        = (1 << 1),
        ClientTime      = (1 << 2),
        Stoppable       = (1 << 3),
        NoHashWait      = (1 << 4),
        Loop            = (1 << 5)
    }

    /// <summary>
    /// Timer subsystem replacement for /tg/-derived codebases.
    /// </summary>
    public class Timers
    {
        private static readonly ConcurrentDictionary<ulong, Timer> _timerLookup = new ConcurrentDictionary<ulong, Timer>();
        private static readonly ConcurrentDictionary<string, Timer> _hashLookup = new ConcurrentDictionary<string, Timer>();
        private static readonly PriorityQueue<Timer> _timers = new PriorityQueue<Timer>(new ReverseComparer());
        private static readonly PriorityQueue<Timer> _realtimeTimers = new PriorityQueue<Timer>(new ReverseComparer());
        private static Timer[] _dispatchedSet = null;
        private static ulong _currentId = 1;

        /// <summary>
        /// Gets the status string of the timer subsystem for the MC tab
        /// </summary>
        /// <returns>A string representing the status of the subsystem</returns>
        [ByondFFI]
        public static string Status()
        {
            return $"BYOND Timers: {_timers.Count}, RWT: {_realtimeTimers.Count}";
        }

        /// <summary>
        /// Fires the subsystem, returning all timers which are to be handled this tick
        /// </summary>
        /// <param name="args">Single item list, the current world.time</param>
        /// <returns>A semi-colon separated list of timer IDs to run, negative if a looped timer.</returns>
        [ByondFFI]
        public static async Task<string> Fire(List<string> args)
        {
            var currentTime = float.Parse(args[0]);
            var result = new ConcurrentBag<Timer>();
            var tasks = new Task[2];

            // Process normal timers
            tasks[0] = Task.Run(() => CollectCompletedTimers(_timers, result, currentTime, false));

            // Process real-time timers
            tasks[1] = Task.Run(() => CollectCompletedTimers(_realtimeTimers, result, currentTime, true));

            await Task.WhenAll(tasks);
            _dispatchedSet = result.ToArray();

            if (_dispatchedSet.Length == 0)
            {
                return null;
            }

            var toReturn = new StringBuilder($"{(_dispatchedSet[0].Flags.HasFlag(TimerFlag.Loop) ? "-" : "")}{_dispatchedSet[0].ID}");
            for (int i = 0; i < _dispatchedSet.Length; i++)
            {
                toReturn.Append($";{(_dispatchedSet[i].Flags.HasFlag(TimerFlag.Loop) ? "-" : "")}{_dispatchedSet[i].ID}");
            }
            return toReturn.ToString();
        }

        /// <summary>
        /// Collects completed timers from the respective priority queue
        /// </summary>
        /// <param name="timers">The priority queue of timers to collect from</param>
        /// <param name="result">The ConcurrentBag to store the resulting timers in</param>
        /// <param name="currentTime">The current world.time</param>
        /// <param name="isRealtime">Boolean operator dictating if these timers are in real-world time</param>
        private static void CollectCompletedTimers(PriorityQueue<Timer> timers, ConcurrentBag<Timer> result, float currentTime, bool isRealtime)
        {
            while (timers.Count > 0 && (isRealtime ? timers.Peek().RealWorldTTR <= DateTime.UtcNow : timers.Peek().TimeToRun <= currentTime))
            {
                var timer = timers.Take();
                if (timer.Flags.HasFlag(TimerFlag.Loop))
                {
                    var copy = timer.Copy();

                    // Update looped time
                    if (isRealtime)
                    {
                        copy.RealWorldTTR = DateTime.UtcNow.AddSeconds(copy.Wait / 10);
                    }
                    else
                    {
                        copy.TimeToRun = currentTime + copy.Wait;
                    }

                    // Keep track of the new copy
                    timers.Add(copy);
                    _timerLookup.AddOrUpdate(copy.ID, copy, (id, _) => copy);
                    if (copy.Hash != null)
                        _hashLookup.AddOrUpdate(copy.Hash, copy, (hash, _) => copy);
                }
                else
                {
                    _timerLookup.Remove(timer.ID, out _);
                    if (timer.Hash != null)
                        _hashLookup.Remove(timer.Hash, out _);
                }
                result.Add(timer);
            }
        }

        /// <summary>
        /// Reports timers that were not fired in time back to the timer subsystem
        /// </summary>
        /// <param name="args">The first non-fired timer</param>
        /// <remarks>Due to issues with DNNE, this method requires returning a string to avoid memory access violations.</remarks>
        [ByondFFI]
        public static string ReportIncompleteTimers(List<string> args)
        {
            if (_dispatchedSet == null)
                return null;

            var lastDispatch = _dispatchedSet.AsSpan();
            var lastId = ulong.Parse(args[0]);
            var foundLast = false;
            for (var cutIdx = 0; cutIdx < lastDispatch.Length; cutIdx++)
            {
                if (!foundLast && lastDispatch[cutIdx].ID == lastId)
                    foundLast = true;
                else if (!foundLast)
                    continue;

                var t = lastDispatch[cutIdx];

                // Add to respective queue
                var selectedQueue = t.IsRealTime ? _realtimeTimers : _timers;

                // Remove the previously-added looped timer from the queue if we are re-adding the old timer
                if (t.Flags.HasFlag(TimerFlag.Loop) && _timerLookup.TryGetValue(t.ID, out var prevTimer))
                {
                    selectedQueue.Remove(prevTimer);
                }

                if (t.Hash != null)
                    _hashLookup.AddOrUpdate(t.Hash, t, (hash, _) => t);
                _timerLookup.AddOrUpdate(t.ID, t, (id, _) => t);
                selectedQueue.Add(t);
            }

            return null;
        }

        /// <summary>
        /// Creates a timer from a set of parameters
        /// </summary>
        /// <returns>The ID of the created timer, if created, or null otherwise</returns>
        [ByondFFI]
        public static string CreateTimer(List<string> args)
        {
            var timer = new Timer()
            {
                Hash = args[0],
                Callback = args[1],
                TimeToRun = float.Parse(args[2]),
                Wait = float.Parse(args[3]),
                Source = args[4],
                Name = args[5],
                Flags = (TimerFlag)int.Parse(args[6])
            };

            string deletedCallback = null;
            if (timer.Flags.HasFlag(TimerFlag.ClientTime))
                timer.RealWorldTTR = DateTime.UtcNow.AddSeconds(timer.Wait / 10);
            var selectedQueue = timer.IsRealTime ? _realtimeTimers : _timers;

            if (timer.Hash != null)
            {
                if (_hashLookup.TryGetValue(timer.Hash, out var prevTimer) && !timer.Flags.HasFlag(TimerFlag.Override))
                {
                    return null;
                }
                else if (prevTimer != null && timer.Flags.HasFlag(TimerFlag.Unique))
                {
                    timer.ID = prevTimer.ID;
                    deletedCallback = prevTimer.Callback;
                    selectedQueue.Remove(prevTimer);
                }
            }

            if (timer.ID == default)
            {
                timer.ID = Interlocked.Increment(ref _currentId);
            }

            selectedQueue.Add(timer);
            _timerLookup.AddOrUpdate(timer.ID, timer, (id, _) => timer);
            if (timer.Hash != null)
                _hashLookup.AddOrUpdate(timer.Hash, timer, (id, _) => timer);
            return $"{timer.ID}";
        }

        /// <summary>
        /// Deletes a timer by ID
        /// </summary>
        /// <returns>The ID of the timer if found and deleted</returns>
        [ByondFFI]
        public static string DeleteTimerByID(List<string> args)
        {
            var id = ulong.Parse(args[0]);
            if (_timerLookup.TryGetValue(id, out var timer) && timer.Flags.HasFlag(TimerFlag.Stoppable))
            {
                DequeueTimer(timer);
                return $"{timer.ID}";
            }
            return null;
        }

        /// <summary>
        /// Deletes a timer by hash
        /// </summary>
        /// <returns>The ID of the timer if found and deleted</returns>
        [ByondFFI]
        public static string DeleteTimerByHash(List<string> args)
        {
            if (_hashLookup.TryGetValue(args[0], out var timer) && timer.Flags.HasFlag(TimerFlag.Stoppable))
            {
                DequeueTimer(timer);
                return $"{timer.ID}";
            }
            return null;
        }

        /// <summary>
        /// Gets the remaining time for a timer
        /// </summary>
        /// <returns>The time in deciseconds if found, otherwise null</returns>
        [ByondFFI]
        public static string TimeLeft(List<string> args)
        {
            var worldTime = float.Parse(args[0]);
            var id = ulong.Parse(args[1]);
            if (_timerLookup.TryGetValue(id, out var timer))
            {
                return timer.IsRealTime
                    ? ((timer.RealWorldTTR.Value - DateTime.UtcNow).TotalSeconds * 10.0).ToString()
                    : (timer.TimeToRun - worldTime).ToString();
            }
            return null;
        }

        /// <summary>
        /// Immediately invokes a timer, removing it from the queue and returning the ID to be used to fire the callback.
        /// </summary>
        /// <returns>The ID of the timer if found</returns>
        [ByondFFI]
        public static string InvokeImmediately(List<string> args)
        {
            var id = ulong.Parse(args[0]);
            if (_timerLookup.TryGetValue(id, out var timer))
            {
                DequeueTimer(timer);
                return $"{timer.ID}";
            }
            return null;
        }

        /// <summary>
        /// Removes a timer from its respective priority queue, and removes it from the lookup dictionaries.
        /// </summary>
        /// <param name="timer">The timer to dequeue</param>
        private static void DequeueTimer(Timer timer)
        {
            _timerLookup.Remove(timer.ID, out _);
            if (timer.Hash != null)
                _hashLookup.Remove(timer.Hash, out _);
            var selectedQueue = timer.IsRealTime ? _realtimeTimers : _timers;
            selectedQueue.Remove(timer);
        }
    }

    public record Timer
    {
        public ulong ID;
        public string Hash;
        public string Callback;
        public float Wait;
        public string Source;
        public string Name;
        public TimerFlag Flags;
        public float TimeToRun;
        public DateTime? RealWorldTTR;
        public bool IsRealTime => RealWorldTTR.HasValue;
        public Timer Copy()
        {
            return (Timer)MemberwiseClone();
        }
    }

    public class ReverseComparer : IComparer<Timer>
    {
        public int Compare(Timer x, Timer y)
        {
            if (x is null || y is null)
                return x is null && y is null ? 0 : (x == null ? -1 : 1);
            if (x.Flags.HasFlag(TimerFlag.ClientTime))
                return x.RealWorldTTR == y.RealWorldTTR ? 0 : (x.RealWorldTTR > y.RealWorldTTR ? -1 : 1);
            return x.TimeToRun == y.TimeToRun ? 0 : (x.TimeToRun > y.TimeToRun ? -1 : 1);
        }
    }
}
