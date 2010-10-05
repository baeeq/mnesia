%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 1997-2010. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% %CopyrightEnd%
%%

%%
-module(mnesia_SUITE).
-author('hakan@erix.ericsson.se').
-compile([export_all]).
-include("mnesia_test_lib.hrl").

init_per_testcase(Func, Conf) ->
    mnesia_test_lib:init_per_testcase(Func, Conf).

end_per_testcase(Func, Conf) ->
    mnesia_test_lib:end_per_testcase(Func, Conf).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all(doc) ->
    ["Verify that Mnesia really is a distributed real-time DBMS",
     "This is the test suite of the Mnesia DBMS. The test suite",
     "covers many aspects of usage and is indended to be developed",
     "incrementally. The test suite is divided into a hierarchy of test",
     "suites where the leafs actually implements the test cases.",
     "The intention of each test case and sub test suite can be",
     "read in comments where they are implemented or in worst cases",
     "from their long mnemonic names. ",
     "",
     "The most simple test case of them all is called 'silly'",
     "and is useful to run now and then, e.g. when some new fatal",
     "bug has been introduced. It may be run even if Mnesia is in",
     "such a bad shape that the test machinery cannot be used.",
     "NB! Invoke the function directly with mnesia_SUITE:silly()",
     "and do not involve the normal test machinery."];
all(suite) ->
    [
     light,
     medium,
     heavy,
     clean_up_suite
    ].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
silly() ->
    mnesia_install_test:silly().
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
light(doc) ->
    ["The 'light' test suite runs a selected set of test suites and is",
     "intended to be the smallest test suite that is meaningful",
     "to run. It starts with an installation test (which in essence is the",
     "'silly' test case) and then it covers all functions in the API in",
     "various depths. All configuration parameters and examples are also",
     "covered."];
light(suite) ->
    [
     install,
     nice,
     evil,
     {mnesia_frag_test, light},
     qlc,
     registry,
     config,     
     examples
    ].

install(suite) ->
    [{mnesia_install_test, all}].

nice(suite) ->
    [{mnesia_nice_coverage_test, all}].

evil(suite) ->
    [{mnesia_evil_coverage_test, all}].

qlc(suite) ->
    [{mnesia_qlc_test, all}].

registry(suite) ->
    [{mnesia_registry_test, all}].

config(suite) ->
    [{mnesia_config_test, all}].

examples(suite) ->
    [{mnesia_examples_test, all}].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
medium(doc) ->
    ["The 'medium' test suite verfies the ACID (atomicity, consistency",
     "isolation and durability) properties and various recovery scenarios",
     "These tests may take quite while to run."];
medium(suite) ->
    [
     install,
     atomicity,
     isolation,
     durability,
     recovery,
     consistency,
     {mnesia_frag_test, medium}
    ].

atomicity(suite) ->
     [{mnesia_atomicity_test, all}].
   
isolation(suite) ->
    [{mnesia_isolation_test, all}].

durability(suite) ->
    [{mnesia_durability_test, all}].

recovery(suite) ->
    [{mnesia_recovery_test, all}].

consistency(suite) ->
     [{mnesia_consistency_test, all}].
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
heavy(doc) ->
    ["The 'heavy' test suite runs some resource consuming tests and",
     "benchmarks"];
heavy(suite) ->
    [measure].

measure(suite) ->
    [{mnesia_measure_test, all}].

prediction(suite) ->
    [{mnesia_measure_test, prediction}].

fairness(suite) ->
    [{mnesia_measure_test, fairness}].

benchmarks(suite) ->
    [{mnesia_measure_test, benchmarks}].

consumption(suite) ->
    [{mnesia_measure_test, consumption}].

scalability(suite) ->
    [{mnesia_measure_test, scalability}].


clean_up_suite(doc) -> ["Not a test case only kills mnesia and nodes, that where" 
			"started during the tests"];
clean_up_suite(suite) ->
    [];
clean_up_suite(Config) when is_list(Config)->
    mnesia:kill(),
    Slaves = mnesia_test_lib:lookup_config(nodenames, Config),
    Nodes = lists:delete(node(), Slaves),
    rpc:multicall(Nodes, erlang, halt, []),
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

otp_r4b(doc) ->
    ["This test suite is an extract of the grand Mnesia suite",
     "it contains OTP R4B specific test cases"];
otp_r4b(suite) ->
    [
     {mnesia_config_test, access_module},
     {mnesia_config_test, dump_log_load_regulation},
     {mnesia_config_test, embedded_mnemosyne},
     {mnesia_config_test, ignore_fallback_at_startup},
     {mnesia_config_test, max_wait_for_decision},
     {mnesia_consistency_test, consistency_after_restore},
     {mnesia_evil_backup, restore},
     {mnesia_evil_coverage_test, offline_set_master_nodes},
     {mnesia_evil_coverage_test, record_name},
     {mnesia_evil_coverage_test, user_properties},
     {mnesia_registry_test, all},
     otp_2363
    ].

otp_2363(doc) ->
    ["Index on disc only tables"];
otp_2363(suite) ->
    [
     {mnesia_dirty_access_test, dirty_index_match_object_disc_only},
     {mnesia_dirty_access_test,dirty_index_read_disc_only},
     {mnesia_dirty_access_test,dirty_index_update_bag_disc_only},
     {mnesia_dirty_access_test,dirty_index_update_set_disc_only},
     {mnesia_evil_coverage_test, create_live_table_index_disc_only}
    ].
    


