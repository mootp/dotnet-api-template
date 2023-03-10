using MediatR;
using AutoMapper;
using moo.Domain.Entities;
using moo.Application.Repositories.Common;
using moo.Application.Common.Exceptions;

namespace moo.Application.Fetures.Product.Commands;

public class ProductCreateCommand : IRequest<Guid>
{
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? Desc { get; set; }
}

public class ProductCreateCommandHandler : IRequestHandler<ProductCreateCommand, Guid>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductCreateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Guid> Handle(ProductCreateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var entity = _mapper.Map<MasterProduct>(request);

            await _unitOfWork.MasterProductRepo.AddAsync(entity);

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
