
using System.Globalization;

namespace moo.Application.Common.Exceptions;

public class ErrorException : Exception
{
    public ErrorException()
        : base()
    {
    }

    public ErrorException(string message)
        : base(message)
    {
    }

    public ErrorException(string message, Exception innerException)
        : base(message, innerException)
    {
    }

    public ErrorException(string message, params object[] args)
            : base(string.Format(CultureInfo.CurrentCulture, message, args))
    {
    }
}
