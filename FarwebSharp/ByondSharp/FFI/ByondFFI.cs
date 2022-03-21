using System;
using System.Runtime.InteropServices;

namespace ByondSharp.FFI
{
    /// <summary>
    /// Facilitates the return of data to BYOND through the FFI
    /// </summary>
    public class ByondFFI
    {
        /// <summary>
        /// Pointer to the last string sent to BYOND
        /// </summary>
        /// <remarks>
        /// This is very important in reducing memory leaks. We will deallocate this string in every following call.
        /// </remarks>
        private static IntPtr _returnString;

        /// <summary>
        /// Generates a response for BYOND, specifically a pointer to a c string
        /// </summary>
        /// <param name="s">The string to be returned to BYOND</param>
        /// <returns>A pointer to the location of the c string in the heap</returns>
        /// <remarks>This MUST be properly freed else it will create a memory leak</remarks>
        public static IntPtr FFIReturn(string s)
        {
            if (_returnString != IntPtr.Zero)
            {
                Marshal.FreeHGlobal(_returnString);
            }
            _returnString = Marshal.StringToHGlobalAnsi(s);
            return _returnString;
        }

        public static IntPtr FFIReturn(ByondResponse response)
        {
            return FFIReturn(response.ToString());
        }
    }
}
