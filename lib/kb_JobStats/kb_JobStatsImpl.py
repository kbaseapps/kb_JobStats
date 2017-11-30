# -*- coding: utf-8 -*-
#BEGIN_HEADER
import logging
from core.UJS_CAT_NJS_DataUtils import UJS_CAT_NJS_DataUtils
from ujsdb_controller import UJSmongoDBController
#END_HEADER


class kb_JobStats:
    '''
    Module Name:
    kb_JobStats

    Module Description:
    A KBase module: kb_JobStats
This KBase SDK module implements methods for generating various KBase metrics on user job states.
    '''

    ######## WARNING FOR GEVENT USERS ####### noqa
    # Since asynchronous IO can lead to methods - even the same method -
    # interrupting each other, you must be *very* careful when using global
    # state. A method could easily clobber the state set by another while
    # the latter method is running.
    ######################################### noqa
    VERSION = "0.0.1"
    GIT_URL = "https://github.com/kbaseapps/kb_JobStats.git"
    GIT_COMMIT_HASH = "57413c650470f69cbce832ca8bef4ce3cfbbb8a5"

    #BEGIN_CLASS_HEADER
    #END_CLASS_HEADER

    # config contains contents of config file in a hash or None if it couldn't
    # be found
    def __init__(self, config):
        #BEGIN_CONSTRUCTOR
        self.__LOGGER = logging.getLogger('UJS_CAT_NJS_DataUtils')
        self.__LOGGER.setLevel(logging.INFO)
        self.config = config
        self.scratch = config['scratch']
        self.ws_url = config['workspace-url']
        self.ujs_cat_njs_util = UJS_CAT_NJS_DataUtils(self.config)
        self.ujsc = UJSmongoDBController(self.config);
        #END_CONSTRUCTOR
        pass


    def get_app_metrics(self, ctx, params):
        """
        :param params: instance of type "AppMetricsParams" (job_stage has one
           of 'created', 'started', 'complete', 'canceled', 'error' or 'all'
           (default)) -> structure: parameter "user_ids" of list of type
           "user_id" (A string for the user id), parameter "time_range" of
           type "time_range" (A time range defined by its lower and upper
           bound.) -> tuple of size 2: parameter "t_lowerbound" of type
           "timestamp" (A time in the format YYYY-MM-DDThh:mm:ssZ, where Z is
           the difference in time to UTC in the format +/-HHMM, eg:
           2012-12-17T23:24:06-0500 (EST time) 2013-04-03T08:56:32+0000 (UTC
           time)), parameter "t_upperbound" of type "timestamp" (A time in
           the format YYYY-MM-DDThh:mm:ssZ, where Z is the difference in time
           to UTC in the format +/-HHMM, eg: 2012-12-17T23:24:06-0500 (EST
           time) 2013-04-03T08:56:32+0000 (UTC time)), parameter "job_stage"
           of String
        :returns: instance of type "AppMetricsResult" -> structure: parameter
           "job_states" of list of type "job_state" (Arbitrary key-value
           pairs about a job.) -> mapping from String to String
        """
        # ctx is the context object
        # return variables are: output
        #BEGIN get_app_metrics
        output = self.ujs_cat_njs_util.generate_app_metrics(params, ctx['token'])
        #END get_app_metrics

        # At some point might do deeper type checking...
        if not isinstance(output, dict):
            raise ValueError('Method get_app_metrics return value ' +
                             'output is not type dict as required.')
        # return the results
        return [output]

    def get_user_metrics(self, ctx, params):
        """
        :param params: instance of type "UserMetricsParams" -> structure:
           parameter "filter_str" of String
        :returns: instance of type "UserMetricsResult" -> structure:
           parameter "user_metrics" of unspecified object
        """
        # ctx is the context object
        # return variables are: output
        #BEGIN get_user_metrics
        output = self.ujs_cat_njs_util.generate_user_metrics(params, ctx['token'])
        #END get_user_metrics

        # At some point might do deeper type checking...
        if not isinstance(output, dict):
            raise ValueError('Method get_user_metrics return value ' +
                             'output is not type dict as required.')
        # return the results
        return [output]

    def get_user_job_states(self, ctx, params):
        """
        :param params: instance of type "UserJobStatesParams" -> structure:
           parameter "user_ids" of list of type "user_id" (A string for the
           user id), parameter "begin" of Long, parameter "end" of Long
        :returns: instance of type "UserJobStatesResult" -> structure:
           parameter "user_job_states" of unspecified object
        """
        # ctx is the context object
        # return variables are: ujs_records
        #BEGIN get_user_job_states
        ujs_records = self.ujsc.get_user_job_states(ctx['user_id'], params)
        #END get_user_job_states

        # At some point might do deeper type checking...
        if not isinstance(ujs_records, dict):
            raise ValueError('Method get_user_job_states return value ' +
                             'ujs_records is not type dict as required.')
        # return the results
        return [ujs_records]
    def status(self, ctx):
        #BEGIN_STATUS
        returnVal = {'state': "OK",
                     'message': "",
                     'version': self.VERSION,
                     'git_url': self.GIT_URL,
                     'git_commit_hash': self.GIT_COMMIT_HASH}
        #END_STATUS
        return [returnVal]
