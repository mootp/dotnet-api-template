using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using moo.Application.Repositories;
using moo.Application.Repositories.Common;

namespace moo.Infrastructure.Repositories.Common;
public class UnitOfWork<TDbContext> : IUnitOfWork where TDbContext : DbContext
{
    private readonly TDbContext _context;
    private IDbContextTransaction _objTran = null!;
    private Dictionary<Type, object> repositories = null!;
    //===============
    public IMasterProductRepository MasterProductRepo { get; }
    public IMasterProductBarcodeRepository MasterProductBarcodeRepo { get; }

    public UnitOfWork(TDbContext context)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
		
        MasterProductRepo = new MasterProductRepository<TDbContext>(_context);
        MasterProductBarcodeRepo = new MasterProductBarcodeRepository<TDbContext>(_context);
    }

    public async ValueTask DisposeAsync()
    {
        await _context.DisposeAsync();
    }

    public int SaveChanges()
    {
        return _context.SaveChanges();
    }

    public async Task<int> SaveChangesAsync()
    {
        return await _context.SaveChangesAsync();
    }

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        return await _context.SaveChangesAsync(cancellationToken);
    }

    public void BeginTransaction()
    {
        _objTran = _context.Database.BeginTransaction();
    }

    public async Task BeginTransactionAsync()
    {
        _objTran = await _context.Database.BeginTransactionAsync();
    }

    public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
    {
        _objTran = await _context.Database.BeginTransactionAsync(cancellationToken);
    }

    public void Commit()
    {
        _objTran.Commit();
    }

    public async Task CommitAsync()
    {
        await _objTran.CommitAsync();
    }

    public async Task CommitAsync(CancellationToken cancellationToken = default)
    {
        await _objTran.CommitAsync(cancellationToken);
    }

    public void Rollback()
    {
        _objTran.Rollback();
        _objTran.Dispose();
    }

    public async Task RollbackAsync()
    {
        await _objTran.RollbackAsync();
        await _objTran.DisposeAsync();
    }

    public async Task RollbackAsync(CancellationToken cancellationToken = default)
    {
        await _objTran.RollbackAsync(cancellationToken);
        await _objTran.DisposeAsync();
    }

    public IBaseRepository<TEntity> GetRepository<TEntity>() where TEntity : class
    {
        if (repositories == null)
        {
            repositories = new Dictionary<Type, object>();
        }

        var type = typeof(TEntity);
        if (!repositories.ContainsKey(type))
        {
            repositories[type] = new BaseRepository<TEntity>(_context);
        }

        return (IBaseRepository<TEntity>)repositories[type];
    }

}
