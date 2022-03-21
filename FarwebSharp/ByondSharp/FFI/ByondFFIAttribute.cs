using System;

namespace ByondSharp.FFI
{
    /// <summary>
    /// Static methods decorated with this attribute will be compiled into BYOND-callable methods
    /// </summary>
    [AttributeUsage(AttributeTargets.Method)]
    public class ByondFFIAttribute : Attribute 
    {
        public bool Deferrable = false;
    }
}
