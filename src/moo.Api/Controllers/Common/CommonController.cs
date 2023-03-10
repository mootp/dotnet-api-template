using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace moo.Api.Controllers.Common;

[Route("[controller]")]
[ApiController]
public class BaseApiController : ControllerBase
{
    private IMediator _mediator = null!;

    protected IMediator Mediator => _mediator ??= HttpContext.RequestServices.GetRequiredService<IMediator>();
}