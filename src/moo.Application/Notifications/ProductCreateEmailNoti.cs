using MediatR;
using AutoMapper;
using moo.Application.Repositories.Common;
using moo.Application.Services;

namespace moo.Application.Notifications;

public record ProductCreateNotification : INotification
{
    public Guid productId { get; set; }
};

public class ProductCreateNotificationHandler : INotificationHandler<ProductCreateNotification>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;
    private readonly IEmailService _emailSrv;

    public ProductCreateNotificationHandler(IUnitOfWork unitOfWork, IMapper mapper, IEmailService emailSrv)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
        _emailSrv = emailSrv;
    }
    public async Task Handle(ProductCreateNotification notification, CancellationToken cancellationToken)
    {
        await _emailSrv.SendEmailProductAdd(notification.productId);
        await Task.CompletedTask;
    }
}