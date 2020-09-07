package com.qweib.cloud.repository.common;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.settings.query.QuerySolution;
import com.qweib.cloud.core.domain.settings.query.SolutionItem;
import com.qweib.cloud.utils.Collections3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author: jimmy.lin
 * @time: 2019/8/9 18:08
 * @description:
 */
@Repository
public class QuerySolutionRepository {
    @Autowired
    private JdbcDaoTemplatePlud daoTemplate;

    public List<QuerySolution> list(String database, String namespace, Integer userId) {
        String sql = "select * from " + database + ".bsc_query_solution q where q.namespace = ? and (q.creator_id = ? or q.share = 1)";
        return daoTemplate.query(sql, new Object[]{namespace, userId}, new BeanPropertyRowMapper<>(QuerySolution.class));
    }

    public Integer save(QuerySolution solution, String database) {
        return daoTemplate.save(database + ".bsc_query_solution", solution);
    }

    public void remove(Integer id, String database) {
        daoTemplate.deletes("delete from " + database + ".bsc_query_solution where id = ?", id);
    }

    public void removeItemsBySolutionId(Integer solutionId, String database) {
        daoTemplate.deletes("delete from " + database + ".bsc_query_solution_item where solution_id = ?", solutionId);
    }

    public void saveItems(List<SolutionItem> items, String database) {
        if (Collections3.isNotEmpty(items)) {
            for (SolutionItem item : items) {
                daoTemplate.save(database + ".bsc_query_solution_item", item);
            }
        }
    }

    public List<SolutionItem> getItemsBySolutionId(Integer solutionId, String database) {
        String sql = "select * from " + database + ".bsc_query_solution_item i where i.solution_id = ?";
        return daoTemplate.query(sql, new Object[]{solutionId}, new BeanPropertyRowMapper<>(SolutionItem.class));
    }
}
