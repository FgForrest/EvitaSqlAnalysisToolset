drop table if exists t_query_test_execution;

-- creates tables for queries testing logging
create table t_query_test_execution (
    id bigserial not null,
    executionBeginTime timestamp not null,
    executionName varchar(128) null,
    queryName varchar(512) not null,
    executionTime bigint not null,
    constraint cnpk_query_test_execution primary key (id)
);
