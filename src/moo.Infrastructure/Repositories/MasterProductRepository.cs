using Microsoft.EntityFrameworkCore;
using moo.Domain.Entities;
using moo.Application.Repositories;
using moo.Infrastructure.Repositories.Common;

namespace moo.Infrastructure.Repositories;
public class MasterProductRepository<TDbContext> : BaseRepository<MasterProduct>, IMasterProductRepository where TDbContext : DbContext
{
    public MasterProductRepository(TDbContext context) : base(context)
    {
    }

    private IQueryable<MasterProduct> Query(bool includeDetail = false)
    {
        if (includeDetail)
        {
            return _dbSet.Include(o => o.Barcode);
        }

        return _dbSet;
    }


    public IQueryable<MasterProduct> GetQueryable(bool includeDetail = false)
    {
        return Query(includeDetail).AsNoTracking();
    }
}