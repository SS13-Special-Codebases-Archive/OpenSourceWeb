using ByondSharp.FFI;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace ByondSharp.Deferred
{
    public class TaskManager
    {
        private static ulong _currentId = 0;
        public static ConcurrentDictionary<ulong, Task<string>> Jobs { get; } = new ConcurrentDictionary<ulong, Task<string>>();

        [ByondFFI]
        public static string PollJobs()
        {
            return string.Join(";", Jobs.Where(x => x.Value.IsCompleted).Select(x => x.Key));
        }

        [ByondFFI]
        public static string GetResult(List<string> args)
        {
            if (args.Count == 0)
                return null;

            if (!ulong.TryParse(args[0], out var id))
            {
                throw new Exception($"Could not parse {args[0]} as a valid job ID, is this really a ulong?");
            }

            if (!Jobs.TryRemove(id, out var job))
            {
                throw new Exception($"ID {id} not present in TaskManager, was this job already collected?");
            }

            if (!job.IsCompleted)
            {
                throw new Exception($"Cannot collect job results, job {id} is not yet complete.");
            }

            return job.Result;
        }

        public static ulong RunTask(Task<string> job)
        {
            if (job.Status == TaskStatus.Created)
                job.Start();
            var id = Interlocked.Increment(ref _currentId);
            if (!Jobs.TryAdd(id, job))
            {
                throw new Exception($"Attempted to schedule job {id}, but the ID was already used for scheduling. Please report this!");
            }
            return id;
        }
    }
}
