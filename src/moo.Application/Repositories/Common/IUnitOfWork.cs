
namespace moo.Application.Repositories.Common;

public interface IUnitOfWork : IAsyncDisposable
{
    int SaveChanges();
    Task<int> SaveChangesAsync();
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    void BeginTransaction();
    Task BeginTransactionAsync();
    Task BeginTransactionAsync(CancellationToken cancellationToken = default);
    void Commit();
    Task CommitAsync();
    Task CommitAsync(CancellationToken cancellationToken = default);
    void Rollback();
    Task RollbackAsync();
    Task RollbackAsync(CancellationToken cancellationToken = default);
    IBaseRepository<TEntity> GetRepository<TEntity>() where TEntity : class;
    //===============
    public IMasterProductRepository MasterProductRepo { get; }
    public IMasterProductBarcodeRepository MasterProductBarcodeRepo { get; }

}