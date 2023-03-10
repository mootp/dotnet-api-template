using moo.Domain.Entities;
using moo.Application.Repositories.Common;

namespace moo.Application.Repositories;
public interface IMasterProductBarcodeRepository : IBaseRepository<MasterProductBarcode>
{
    IQueryable<MasterProductBarcode> GetQueryable(bool includeDetail = false);
}
