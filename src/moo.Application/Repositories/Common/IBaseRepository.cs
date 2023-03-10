using System.Linq.Expressions;

namespace moo.Application.Repositories.Common;

public interface IBaseRepository<TEntity> where TEntity : class
{
    void Add(TEntity entity);
    void AddRange(IEnumerable<TEntity> entities);
    Task AddAsync(TEntity entity);
    Task AddRangeAsync(IEnumerable<TEntity> entities);
    void Update(TEntity entity);
    void UpdateRange(IEnumerable<TEntity> entities);
    void Remove(TEntity entity);
    void RemoveRange(IEnumerable<TEntity> entities);
    TEntity? Find(params object?[]? keyValues);
    Task<TEntity?> FindAsync(params object[] keyValues);
    IQueryable<TEntity> Where(Expression<Func<TEntity, bool>> predicate);
    TEntity? FirstOrDefault();
    TEntity? FirstOrDefault(Expression<Func<TEntity, bool>> predicate);
    Task<TEntity?> FirstOrDefaultAsync();
    Task<TEntity?> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate);
    TEntity? SingleOrDefault();
    TEntity? SingleOrDefault(Expression<Func<TEntity, bool>> predicate);
    Task<TEntity?> SingleOrDefaultAsync();
    Task<TEntity?> SingleOrDefaultAsync(Expression<Func<TEntity, bool>> predicate);

}
