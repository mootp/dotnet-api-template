using Microsoft.EntityFrameworkCore;
using moo.Domain.Entities;
using moo.Application.Repositories;
using moo.Infrastructure.Repositories.Common;

namespace moo.Infrastructure.Repositories;
public class MasterProductBarcodeRepository<TDbContext> : BaseRepository<MasterProductBarcode>, IMasterProductBarcodeRepository where TDbContext : DbContext
{
    public MasterProductBarcodeRepository(TDbContext context) : base(context)
    {
    }

    private IQueryable<MasterProductBarcode> Query(bool includeDetail = false)
    {
        if (includeDetail)
        {
            return _dbSet;
        }

        return _dbSet;
    }


    public IQueryable<MasterProductBarcode> GetQueryable(bool includeDetail = false)
    {
        return Query(includeDetail).AsNoTracking();
    }
}