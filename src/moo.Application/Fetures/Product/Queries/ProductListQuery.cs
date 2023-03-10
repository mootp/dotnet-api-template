using MediatR;
using AutoMapper;
using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using moo.Application.Repositories.Common;
using moo.Domain.Entities;
using moo.Application.Common.Models;
using moo.Application.Common.Helpers;
using moo.Application.Fetures.Product.DTOs;

namespace moo.Application.Fetures.Product.Queries;

public class ProductWithPaginationQuery : IRequest<Pagination<ProductDto>>
{
    public string? Search { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 10;
    public string? SortColumn { get; set; }
    public string? SortDirection { get; set; }
}

public class ProductWithPaginationQueryHandler : IRequestHandler<ProductWithPaginationQuery, Pagination<ProductDto>>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductWithPaginationQueryHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Pagination<ProductDto>> Handle(ProductWithPaginationQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductRepo.GetQueryable(false);

        if (request.Search != null)
        {
            string[] words = request.Search.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            // query = query.Where(x => words.Contains(x.Code) || words.Contains(x.Name) || words.Contains(x.Desc));
            query = query.WhereAny(words.Select(w => (Expression<Func<MasterProduct, bool>>)(x =>
                EF.Functions.Like(x.Code.ToLower().Trim(), "%" + w.ToLower().Trim() + "%") ||
                EF.Functions.Like(x.Name.ToLower().Trim(), "%" + w.ToLower().Trim() + "%") ||
                EF.Functions.Like((x.Desc ?? "").ToLower().Trim(), "%" + w.ToLower().Trim() + "%")
            )).ToArray());
        }
        return await query.GetPagination<MasterProduct, ProductDto>(request.PageNumber, request.PageSize, request.SortColumn, request.SortDirection);

    }
}
