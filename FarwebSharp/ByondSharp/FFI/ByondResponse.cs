using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace ByondSharp.FFI
{
    public enum ResponseCode
    {
        Unknown,
        Success,
        Error,
        Deferred
    }

    public struct ByondResponse
    {
        private static readonly JsonSerializerOptions _jsonSerializerConfig = new JsonSerializerOptions() { IncludeFields = true };

        public ResponseCode ResponseCode;
        [JsonIgnore]
        public Exception _Exception;
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string Exception => _Exception?.ToString();
        public string Data;

        public override string ToString()
        {
            return JsonSerializer.Serialize(this, _jsonSerializerConfig);
        }
    }
}
