# -*- coding: utf-8 -*-
############################################################
#
# Autogenerated by the KBase type compiler -
# any changes made here will be overwritten
#
############################################################

from __future__ import print_function
# the following is a hack to get the baseclient to import whether we're in a
# package or not. This makes pep8 unhappy hence the annotations.
try:
    # baseclient and this client are in a package
    from .baseclient import BaseClient as _BaseClient  # @UnusedImport
except:
    # no they aren't
    from baseclient import BaseClient as _BaseClient  # @Reimport


class kb_JobStats(object):

    def __init__(
            self, url=None, timeout=30 * 60, user_id=None,
            password=None, token=None, ignore_authrc=False,
            trust_all_ssl_certificates=False,
            auth_svc='https://kbase.us/services/authorization/Sessions/Login'):
        if url is None:
            raise ValueError('A url is required')
        self._service_ver = None
        self._client = _BaseClient(
            url, timeout=timeout, user_id=user_id, password=password,
            token=token, ignore_authrc=ignore_authrc,
            trust_all_ssl_certificates=trust_all_ssl_certificates,
            auth_svc=auth_svc)

    def get_app_metrics(self, params, context=None):
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
        return self._client.call_method(
            'kb_JobStats.get_app_metrics',
            [params], self._service_ver, context)

    def status(self, context=None):
        return self._client.call_method('kb_JobStats.status',
                                        [], self._service_ver, context)
