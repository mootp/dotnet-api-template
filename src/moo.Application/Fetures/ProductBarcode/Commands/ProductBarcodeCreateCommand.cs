
using MediatR;
using AutoMapper;
using moo.Domain.Entities;
using moo.Application.Repositories.Common;
using moo.Application.Common.Exceptions;

namespace moo.Application.Fetures.ProductBarcode.Commands;

public class ProductBarcodeCreateCommand : IRequest<Guid>
{
    public Guid ProductId { get; set; }
    public string Barcode { get; set; } = null!;
    public string? Desc { get; set; }
}

public class ProductBarcodeCreateCommandHandler : IRequestHandler<ProductBarcodeCreateCommand, Guid>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeCreateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Guid> Handle(ProductBarcodeCreateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var entity = _mapper.Map<MasterProductBarcode>(request);

            await _unitOfWork.MasterProductBarcodeRepo.AddAsync(entity);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return entity.Id;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw new ErrorException(ex.Message);
        }
    }
}
