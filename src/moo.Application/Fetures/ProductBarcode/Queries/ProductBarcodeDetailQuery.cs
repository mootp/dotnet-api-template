using MediatR;
using AutoMapper;
using moo.Application.Repositories.Common;
using moo.Application.Fetures.ProductBarcode.DTOs;

namespace moo.Application.Fetures.ProductBarcode.Queries;

public class ProductBarcodeDetailQuery : IRequest<ProductBarcodeDto>
{
    public Guid Id { get; set; }
}

public class ProductBarcodeDetailQueryHandler : IRequestHandler<ProductBarcodeDetailQuery, ProductBarcodeDto>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeDetailQueryHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<ProductBarcodeDto> Handle(ProductBarcodeDetailQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductBarcodeRepo.GetQueryable(true).FirstOrDefault(x => x.Id == request.Id);
        
        var rtn =  _mapper.Map<ProductBarcodeDto>(query);

        return await Task.FromResult(rtn);
    }
}
