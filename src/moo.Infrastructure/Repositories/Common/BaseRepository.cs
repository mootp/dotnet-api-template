using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using moo.Application.Repositories.Common;

namespace moo.Infrastructure.Repositories.Common;

public class BaseRepository<TEntity> : IBaseRepository<TEntity> where TEntity : class
{
    internal DbSet<TEntity> _dbSet;
    protected readonly DbContext _context;

    public BaseRepository(DbContext context)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
        _dbSet = _context.Set<TEntity>();
    }

    public void Add(TEntity entity) => _dbSet.Add(entity);
    public void AddRange(IEnumerable<TEntity> entities) => _dbSet.AddRange(entities);
    public async Task AddAsync(TEntity entity) => await _dbSet.AddAsync(entity);
    public async Task AddRangeAsync(IEnumerable<TEntity> entities) => await _dbSet.AddRangeAsync(entities);
    public void Update(TEntity entity) => _dbSet.Update(entity);
    public void UpdateRange(IEnumerable<TEntity> entities) => _dbSet.UpdateRange(entities);
    public void Remove(TEntity entity) => _dbSet.Remove(entity);
    public void RemoveRange(IEnumerable<TEntity> entities) => _dbSet.RemoveRange(entities);
    public TEntity? Find(params object?[]? keyValues) => _dbSet.Find(keyValues);
    public async Task<TEntity?> FindAsync(params object[] keyValues) => await _dbSet.FindAsync(keyValues);
    public IQueryable<TEntity> Where(Expression<Func<TEntity, bool>> predicate) => _dbSet.Where(predicate);
    public TEntity? FirstOrDefault() => _dbSet.FirstOrDefault();
    public TEntity? FirstOrDefault(Expression<Func<TEntity, bool>> predicate) => _dbSet.FirstOrDefault(predicate);
    public async Task<TEntity?> FirstOrDefaultAsync() => await _dbSet.FirstOrDefaultAsync();
    public async Task<TEntity?> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate) => await _dbSet.FirstOrDefaultAsync(predicate);
    public TEntity? SingleOrDefault() => _dbSet.SingleOrDefault();
    public TEntity? SingleOrDefault(Expression<Func<TEntity, bool>> predicate) => _dbSet.SingleOrDefault(predicate);
    public async Task<TEntity?> SingleOrDefaultAsync() => await _dbSet.SingleOrDefaultAsync();
    public async Task<TEntity?> SingleOrDefaultAsync(Expression<Func<TEntity, bool>> predicate) => await _dbSet.SingleOrDefaultAsync(predicate);
}
