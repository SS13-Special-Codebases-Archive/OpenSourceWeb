using RestSharp;
using ByondSharp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Toolkit.HighPerformance;

namespace ByondSharp
{
    /// <summary>
    /// This is provided as an example for external library use, with RestSharp, as well as an async method call. This is a sample adapted from the Scrubby parsing server.
    /// </summary>
    public class BYONDDataService
    {
        const string BaseURL = "https://www.byond.com/";
        readonly IRestClient _client;

        public BYONDDataService()
        {
            _client = new RestClient(BaseURL);
        }

        public async Task<BYONDUserData> GetUserData(string key, CancellationToken cancellationToken)
        {
            var request = new RestRequest($"members/{key}", Method.GET, DataFormat.None).AddQueryParameter("format", "text");
            var response = await _client.ExecuteAsync(request, cancellationToken);

            if (response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                return null;
            }

            if (response.Content.Contains($"not found.</div>"))
            {
                throw new BYONDUserNotFoundException($"User {key} not found.");
            }

            if (response.Content.Contains($"is not active.</div>"))
            {
                throw new BYONDUserInactiveException($"User {key} is not active.");
            }

            return ParseResponse(response.Content.AsSpan());
        }

        private static BYONDUserData ParseResponse(ReadOnlySpan<char> data)
        {
            var toReturn = new BYONDUserData();

            foreach(var line in data.Tokenize('\n'))
            {
                if (line.StartsWith("general"))
                {
                    continue;
                }
                
                var lineContext = line.Trim("\r\t ");
                var equalsLoc = lineContext.IndexOf('=');
                if (equalsLoc == -1)
                    continue;

                var key = lineContext[0..equalsLoc].Trim();
                var value = lineContext[(equalsLoc + 1)..^0].Trim("\" ");
                if (key.Equals("key", StringComparison.OrdinalIgnoreCase))
                {
                    toReturn.Key = value.ToString();
                }
                else if (key.Equals("ckey", StringComparison.OrdinalIgnoreCase))
                {
                    toReturn.CKey = value.ToString();
                }
                else if (key.Equals("gender", StringComparison.OrdinalIgnoreCase))
                {
                    toReturn.Gender = value.ToString();
                }
                else if (key.Equals("joined", StringComparison.OrdinalIgnoreCase))
                {
                    toReturn.Joined = DateTime.SpecifyKind(DateTime.Parse(value), DateTimeKind.Utc);
                }
                else if (key.Equals("is_member", StringComparison.OrdinalIgnoreCase))
                {
                    toReturn.IsMember = value.Equals("1", StringComparison.OrdinalIgnoreCase);
                }
            }

            return toReturn;
        }
    }

    public class BYONDUserNotFoundException : Exception
    {
        public BYONDUserNotFoundException() : base() { }
        public BYONDUserNotFoundException(string message) : base(message) { }
        public BYONDUserNotFoundException(string message, Exception inner) : base(message, inner) { }

        protected BYONDUserNotFoundException(System.Runtime.Serialization.SerializationInfo info,
            System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
    }

    public class BYONDUserInactiveException : Exception
    {
        public BYONDUserInactiveException() : base() { }
        public BYONDUserInactiveException(string message) : base(message) { }
        public BYONDUserInactiveException(string message, Exception inner) : base(message, inner) { }

        protected BYONDUserInactiveException(System.Runtime.Serialization.SerializationInfo info,
            System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
    }
}
