package io.evitadb.referential.sql.spike_test.queries_measurement;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Application for measuring queries execution times.
 *
 * <h3>Parameters:</h3>
 * <ul>
 *     <li>1. - path of directory with queries</li>
 *     <li>2. - name of execution</li>
 * </ul>
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
public class QueriesMeasurementApplication implements CommandLineRunner {

    @Autowired
    private ResourceLoader resourceLoader;

    public static void main(String[] args) {
        SpringApplication.run(QueriesMeasurementApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("Connecting to db...");
        final DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("org.postgresql.Driver");
        dataSource.setUrl("jdbc:postgresql://localhost:5432/evita_db");
        dataSource.setUsername("postgres");
        dataSource.setPassword("JQD2BrFiJeEtVh");
        System.out.println("Connected.");

        final JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

        String executionName = "";
        if ((args != null) && (args.length > 1)) {
            executionName = args[1];
        }
        final LocalDateTime executionBeginTime = LocalDateTime.now();
        final List<QueryExecution> queriesExecutions = new ArrayList<>();

        System.out.println("Loading queries...");
        final Resource[] queriesFiles = new PathMatchingResourcePatternResolver(resourceLoader).getResources("file:" + Paths.get(args[0], "*").toString());
        System.out.println("Loaded " + queriesFiles.length + " queries.");

        for (Resource queryFile : queriesFiles) {
            String query = "";
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(queryFile.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    query += " " + line;
                }
            }

            System.out.println("Executing query " + queryFile.getFilename() + " ...");
            final LocalDateTime queryExecutionStartTime = LocalDateTime.now();
            jdbcTemplate.execute(query);
            final LocalDateTime queryExecutionEndTime = LocalDateTime.now();
            System.out.println("Query executed.");

            queriesExecutions.add(new QueryExecution(queryFile.getFilename(), Duration.between(queryExecutionStartTime, queryExecutionEndTime)));
        }

        System.out.println("Logging results to console and db...");
        System.out.println("-----------------");
        for (QueryExecution queryExecution : queriesExecutions) {
            System.out.println("Script: " + queryExecution.getQueryName() + " execution time: " + queryExecution.getExecutionTime().toMillis() + " ms");
            jdbcTemplate.update(
                    "insert into t_query_test_execution (executionBeginTime, executionName, queryName, executionTime) values (?, ?, ?, ?)",
                    executionBeginTime,
                    executionName,
                    queryExecution.getQueryName(),
                    queryExecution.getExecutionTime().toMillis()
            );
        }

        System.out.println("Done. Bye.");
    }

    @Data
    private static class QueryExecution {
        private final String queryName;
        private final Duration executionTime;
    }
}
