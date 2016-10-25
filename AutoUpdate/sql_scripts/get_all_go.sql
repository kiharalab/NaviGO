SELECT DISTINCT         
            ancestor.acc, term.acc  
            FROM    term   
            INNER JOIN graph_path ON (term.id=graph_path.term2_id)   
            INNER JOIN term AS ancestor ON (ancestor.id=graph_path.term1_id)  
            WHERE term.acc LIKE 'GO:%' AND ancestor.acc LIKE 'GO:%';
