/*
A KBase module: kb_JobStats
This KBase SDK module implements methods for generating various KBase metrics on user job states.
*/

module kb_JobStats {
    /* 
        A 'typedef' allows you to provide a more specific name for
        a type.  Built-in primitive types include 'string', 'int',
        'float'.  Here we define a type named assembly_ref to indicate
        a string that should be set to a KBase ID reference to an
        Assembly data object.
    */

    /* A boolean - 0 for false, 1 for true.
        @range (0, 1)
    */
                    
    typedef int bool;
    /*
        An integer for the workspace id
    */
    typedef int ws_id;
    /*
        A string for the user id
    */
    typedef string user_id;
    /* 
        A time in the format YYYY-MM-DDThh:mm:ssZ, where Z is the difference
        in time to UTC in the format +/-HHMM, eg:
                2012-12-17T23:24:06-0500 (EST time)
                2013-04-03T08:56:32+0000 (UTC time)
    */
    typedef string timestamp;
    /*
        A Unix epoch (the time since 00:00:00 1/1/1970 UTC) in milliseconds.
    */
    typedef int epoch;
    /*
        A time range defined by its lower and upper bound.
    */
    typedef tuple<timestamp t_lowerbound, timestamp t_upperbound> time_range;
    
    /*job_stage has one of 'created', 'started', 'complete', 'canceled', 'error' or 'all' (default)*/
    typedef structure {
        list<user_id> user_ids;
        time_range time_range;
        string job_stage; 
    } AppMetricsParams;

    /*
        Arbitrary key-value pairs about a job.
    */
    typedef mapping<string, string> job_state;

    typedef structure {
        list<job_state> job_states;
    } AppMetricsResult;
    
    funcdef get_app_metrics(AppMetricsParams params)
        returns (AppMetricsResult output) authentication required;

};
