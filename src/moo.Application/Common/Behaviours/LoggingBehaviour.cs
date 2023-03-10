using MediatR;
using System.Diagnostics;
using Microsoft.Extensions.Logging;

namespace moo.Application.Common.Behaviours;

public class LoggingBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse> where TRequest : IRequest<TResponse>
{
    private readonly Stopwatch _timer;
    private readonly ILogger<TRequest> _logger;

    public LoggingBehavior(ILogger<TRequest> logger)
    {
        _timer = new Stopwatch();

        _logger = logger;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        var requestName = typeof(TRequest).Name;
        _logger.LogInformation("----- Request| {@datetime} | 0  | {@name} | {@request}", DateTime.Now, requestName, request);

        _timer.Start();
        var response = await next();
        _timer.Stop();

        var responseName = typeof(TResponse).Name;
        var seconds = _timer.ElapsedMilliseconds;
        _logger.LogInformation("----- Response | {@datetime} | {@sec} | {@name} | {@response}", DateTime.Now, seconds, responseName, response);

        return response;
    }
}