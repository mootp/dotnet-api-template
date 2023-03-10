using AutoMapper;
using MediatR;
using moo.Application.Repositories.Common;
using moo.Application.Fetures.Product.DTOs;

namespace moo.Application.Fetures.Product.Queries;

public class ProductDetailQuery : IRequest<ProductDto>
{
    public Guid Id { get; set; }
}

public class ProductDetailQueryHandler : IRequestHandler<ProductDetailQuery, ProductDto>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductDetailQueryHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<ProductDto> Handle(ProductDetailQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductRepo.GetQueryable(true).FirstOrDefault(x => x.Id == request.Id);
        
        var rtn =  _mapper.Map<ProductDto>(query);

        return await Task.FromResult(rtn);
    }
}
