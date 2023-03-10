using MediatR;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using moo.Domain.Entities;
using moo.Application.Common.Exceptions;
using moo.Application.Repositories.Common;

namespace moo.Application.Fetures.Product.Commands;

public class ProductUpdateCommand : IRequest
{
    public Guid Id { get; set; }
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? Desc { get; set; }
    
}

public class ProductUpdateCommandHandler : IRequestHandler<ProductUpdateCommand>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductUpdateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Unit> Handle(ProductUpdateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var repo = _unitOfWork.MasterProductRepo;

            var data = await repo.GetQueryable(true).FirstOrDefaultAsync(x => x.Id == request.Id, cancellationToken);

            if (data == null)
            {
                throw new NotFoundException(nameof(MasterProduct), request.Id);
            }

            _mapper.Map(request, data);

            _unitOfWork.MasterProductRepo.Update(data);

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
