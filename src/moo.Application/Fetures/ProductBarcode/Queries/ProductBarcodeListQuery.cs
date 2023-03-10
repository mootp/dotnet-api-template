using MediatR;
using AutoMapper;
using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using moo.Domain.Entities;
using moo.Application.Common.Helpers;
using moo.Application.Repositories.Common;
using moo.Application.Common.Models;
using moo.Application.Fetures.ProductBarcode.DTOs;

namespace moo.Application.Fetures.ProductBarcode.Queries;

public class ProductBarcodeWithPaginationQuery : IRequest<Pagination<ProductBarcodeDto>>
{
    public Guid ProductId { get; set; }
    public string? Search { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 10;
    public string? SortColumn { get; set; }
    public string? SortDirection { get; set; }
}

public class ProductBarcodeWithPaginationQueryHandler : IRequestHandler<ProductBarcodeWithPaginationQuery, Pagination<ProductBarcodeDto>>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeWithPaginationQueryHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Pagination<ProductBarcodeDto>> Handle(ProductBarcodeWithPaginationQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductBarcodeRepo.GetQueryable(false).Where(x => x.ProductId == request.ProductId);

        if (request.Search != null)
        {
            string[] words = request.Search.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            query = query.WhereAny(words.Select(w => (Expression<Func<MasterProductBarcode, bool>>)(x =>
                EF.Functions.Like(x.Barcode.ToLower().Trim(), "%" + w.ToLower().Trim() + "%") ||
                EF.Functions.Like((x.Desc ?? "").ToLower().Trim(), "%" + w.ToLower().Trim() + "%")
            )).ToArray());
        }
        return await query.GetPagination<MasterProductBarcode, ProductBarcodeDto>(request.PageNumber, request.PageSize, request.SortColumn, request.SortDirection);
    }
}
