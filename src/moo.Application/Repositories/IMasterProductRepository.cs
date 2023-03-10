using moo.Domain.Entities;
using moo.Application.Repositories.Common;

namespace moo.Application.Repositories;
public interface IMasterProductRepository : IBaseRepository<MasterProduct>
{
    IQueryable<MasterProduct> GetQueryable(bool includeDetail = false);
}
