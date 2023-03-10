using MediatR;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using moo.Domain.Entities;
using moo.Application.Common.Exceptions;
using moo.Application.Repositories.Common;

namespace moo.Application.Fetures.ProductBarcode.Commands;

public class ProductBarcodeDeleteCommand : IRequest
{
    public Guid Id { get; set; }
}

public class ProductBarcodeDeleteCommandHandler : IRequestHandler<ProductBarcodeDeleteCommand>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeDeleteCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Unit> Handle(ProductBarcodeDeleteCommand request, CancellationToken cancellationToken)
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

            _unitOfWork.MasterProductBarcodeRepo.Remove(data);

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
