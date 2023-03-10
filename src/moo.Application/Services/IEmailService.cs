using moo.Application.Common.Models;

namespace moo.Application.Services;
public interface IEmailService
{
    Task Send(EmailModel model);
    Task SendEmailProductAdd(Guid productId);
}
