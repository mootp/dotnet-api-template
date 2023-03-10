using AutoMapper;
using System.Linq.Dynamic.Core;
using moo.Application.Common.Models;

namespace moo.Application.Common.Helpers;

public static class PaginationExtension
{

    public static async Task<Pagination<TSource>> GetPagination<TSource>(this IQueryable<TSource> query, int? pageNumber, int? pageSize, string? sortColumn, string? sortDirection)
    {
        var total = query.Count();
        if (sortColumn != null && sortDirection != null)
        {
            query = query.OrderBy(sortColumn + " " + sortDirection);
        }
        if (pageNumber != null && pageSize != null)
        {
            query = query.Skip(((pageNumber ?? 1) - 1) * (pageSize ?? 10)).Take((pageSize ?? 10));
        }

        var res = query.ToList();

        var rtn = await Task.FromResult(new Pagination<TSource>
        {
            Total = total,
            Results = res
        });

        return rtn;
    }

    public static async Task<Pagination<TDest>> GetPagination<TSource, TDest>(this IQueryable<TSource> query, int? pageNumber, int? pageSize, string? sortColumn, string? sortDirection)
    {
        var total = query.Count();
        if (sortColumn != null && sortDirection != null)
        {
            query = query.OrderBy(sortColumn + " " + sortDirection);
        }
        if (pageNumber != null && pageSize != null)
        {
            query = query.Skip(((pageNumber ?? 1) - 1) * (pageSize ?? 10)).Take((pageSize ?? 10));
        }

        var tmp = query.ToList();

        var config = new MapperConfiguration(cfg => { cfg.CreateMap<TSource, TDest>(); });
        var mapper = new Mapper(config);

        var res = mapper.Map<List<TDest>>(tmp);

        var rtn = await Task.FromResult(new Pagination<TDest>
        {
            Total = total,
            Results = res
        });

        return rtn;
    }

}

