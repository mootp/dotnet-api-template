using MediatR;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using moo.Domain.Entities;
using moo.Application.Common.Exceptions;
using moo.Application.Repositories.Common;

namespace moo.Application.Fetures.ProductBarcode.Commands;

public class ProductBarcodeUpdateCommand : IRequest
{
    public Guid Id { get; set; }
    public Guid ProductId { get; set; }
    public string Barcode { get; set; } = null!;
    public string? Desc { get; set; }
    
}

public class ProductBarcodeUpdateCommandHandler : IRequestHandler<ProductBarcodeUpdateCommand>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeUpdateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Unit> Handle(ProductBarcodeUpdateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var repo = _unitOfWork.MasterProductBarcodeRepo;

            var data = await repo.GetQueryable(true).FirstOrDefaultAsync(x => x.Id == request.Id, cancellationToken);

            if (data == null)
            {
                throw new NotFoundException(nameof(MasterProductBarcode), request.Id);
            }

            _mapper.Map(request, data);

            _unitOfWork.MasterProductBarcodeRepo.Update(data);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return Unit.Value;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw new ErrorException(ex.Message);
        }
    }
}
