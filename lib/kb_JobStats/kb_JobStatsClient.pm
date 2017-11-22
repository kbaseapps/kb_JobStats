package kb_JobStats::kb_JobStatsClient;

use JSON::RPC::Client;
use POSIX;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
my $get_time = sub { time, 0 };
eval {
    require Time::HiRes;
    $get_time = sub { Time::HiRes::gettimeofday() };
};

use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

kb_JobStats::kb_JobStatsClient

=head1 DESCRIPTION


A KBase module: kb_JobStats
This KBase SDK module implements methods for generating various KBase metrics on user job states.


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => kb_JobStats::kb_JobStatsClient::RpcClient->new,
	url => $url,
	headers => [],
    };

    chomp($self->{hostname} = `hostname`);
    $self->{hostname} ||= 'unknown-host';

    #
    # Set up for propagating KBRPC_TAG and KBRPC_METADATA environment variables through
    # to invoked services. If these values are not set, we create a new tag
    # and a metadata field with basic information about the invoking script.
    #
    if ($ENV{KBRPC_TAG})
    {
	$self->{kbrpc_tag} = $ENV{KBRPC_TAG};
    }
    else
    {
	my ($t, $us) = &$get_time();
	$us = sprintf("%06d", $us);
	my $ts = strftime("%Y-%m-%dT%H:%M:%S.${us}Z", gmtime $t);
	$self->{kbrpc_tag} = "C:$0:$self->{hostname}:$$:$ts";
    }
    push(@{$self->{headers}}, 'Kbrpc-Tag', $self->{kbrpc_tag});

    if ($ENV{KBRPC_METADATA})
    {
	$self->{kbrpc_metadata} = $ENV{KBRPC_METADATA};
	push(@{$self->{headers}}, 'Kbrpc-Metadata', $self->{kbrpc_metadata});
    }

    if ($ENV{KBRPC_ERROR_DEST})
    {
	$self->{kbrpc_error_dest} = $ENV{KBRPC_ERROR_DEST};
	push(@{$self->{headers}}, 'Kbrpc-Errordest', $self->{kbrpc_error_dest});
    }

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my %arg_hash2 = @args;
	if (exists $arg_hash2{"token"}) {
	    $self->{token} = $arg_hash2{"token"};
	} elsif (exists $arg_hash2{"user_id"}) {
	    my $token = Bio::KBase::AuthToken->new(@args);
	    if (!$token->error_message) {
	        $self->{token} = $token->token;
	    }
	}
	
	if (exists $self->{token})
	{
	    $self->{client}->{token} = $self->{token};
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




=head2 get_app_metrics

  $output = $obj->get_app_metrics($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_JobStats.AppMetricsParams
$output is a kb_JobStats.AppMetricsResult
AppMetricsParams is a reference to a hash where the following keys are defined:
	user_ids has a value which is a reference to a list where each element is a kb_JobStats.user_id
	time_range has a value which is a kb_JobStats.time_range
	job_stage has a value which is a string
user_id is a string
time_range is a reference to a list containing 2 items:
	0: (t_lowerbound) a kb_JobStats.timestamp
	1: (t_upperbound) a kb_JobStats.timestamp
timestamp is a string
AppMetricsResult is a reference to a hash where the following keys are defined:
	job_states has a value which is a reference to a list where each element is a kb_JobStats.job_state
job_state is a reference to a hash where the key is a string and the value is a string

</pre>

=end html

=begin text

$params is a kb_JobStats.AppMetricsParams
$output is a kb_JobStats.AppMetricsResult
AppMetricsParams is a reference to a hash where the following keys are defined:
	user_ids has a value which is a reference to a list where each element is a kb_JobStats.user_id
	time_range has a value which is a kb_JobStats.time_range
	job_stage has a value which is a string
user_id is a string
time_range is a reference to a list containing 2 items:
	0: (t_lowerbound) a kb_JobStats.timestamp
	1: (t_upperbound) a kb_JobStats.timestamp
timestamp is a string
AppMetricsResult is a reference to a hash where the following keys are defined:
	job_states has a value which is a reference to a list where each element is a kb_JobStats.job_state
job_state is a reference to a hash where the key is a string and the value is a string


=end text

=item Description



=back

=cut

 sub get_app_metrics
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function get_app_metrics (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to get_app_metrics:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'get_app_metrics');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_JobStats.get_app_metrics",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'get_app_metrics',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method get_app_metrics",
					    status_line => $self->{client}->status_line,
					    method_name => 'get_app_metrics',
				       );
    }
}
 
  
sub status
{
    my($self, @args) = @_;
    if ((my $n = @args) != 0) {
        Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
                                   "Invalid argument count for function status (received $n, expecting 0)");
    }
    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
        method => "kb_JobStats.status",
        params => \@args,
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
                           code => $result->content->{error}->{code},
                           method_name => 'status',
                           data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
                          );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method status",
                        status_line => $self->{client}->status_line,
                        method_name => 'status',
                       );
    }
}
   

sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
        method => "kb_JobStats.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'get_app_metrics',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method get_app_metrics",
            status_line => $self->{client}->status_line,
            method_name => 'get_app_metrics',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for kb_JobStats::kb_JobStatsClient\n";
    }
    if ($sMajor == 0) {
        warn "kb_JobStats::kb_JobStatsClient version is $svr_version. API subject to change.\n";
    }
}

=head1 TYPES



=head2 bool

=over 4



=item Description

A boolean - 0 for false, 1 for true.
@range (0, 1)


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 ws_id

=over 4



=item Description

An integer for the workspace id


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 user_id

=over 4



=item Description

A string for the user id


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 timestamp

=over 4



=item Description

A time in the format YYYY-MM-DDThh:mm:ssZ, where Z is the difference
in time to UTC in the format +/-HHMM, eg:
        2012-12-17T23:24:06-0500 (EST time)
        2013-04-03T08:56:32+0000 (UTC time)


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 epoch

=over 4



=item Description

A Unix epoch (the time since 00:00:00 1/1/1970 UTC) in milliseconds.


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 time_range

=over 4



=item Description

A time range defined by its lower and upper bound.


=item Definition

=begin html

<pre>
a reference to a list containing 2 items:
0: (t_lowerbound) a kb_JobStats.timestamp
1: (t_upperbound) a kb_JobStats.timestamp

</pre>

=end html

=begin text

a reference to a list containing 2 items:
0: (t_lowerbound) a kb_JobStats.timestamp
1: (t_upperbound) a kb_JobStats.timestamp


=end text

=back



=head2 AppMetricsParams

=over 4



=item Description

job_stage has one of 'created', 'started', 'complete', 'canceled', 'error' or 'all' (default)


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
user_ids has a value which is a reference to a list where each element is a kb_JobStats.user_id
time_range has a value which is a kb_JobStats.time_range
job_stage has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
user_ids has a value which is a reference to a list where each element is a kb_JobStats.user_id
time_range has a value which is a kb_JobStats.time_range
job_stage has a value which is a string


=end text

=back



=head2 job_state

=over 4



=item Description

Arbitrary key-value pairs about a job.


=item Definition

=begin html

<pre>
a reference to a hash where the key is a string and the value is a string
</pre>

=end html

=begin text

a reference to a hash where the key is a string and the value is a string

=end text

=back



=head2 AppMetricsResult

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
job_states has a value which is a reference to a list where each element is a kb_JobStats.job_state

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
job_states has a value which is a reference to a list where each element is a kb_JobStats.job_state


=end text

=back



=cut

package kb_JobStats::kb_JobStatsClient::RpcClient;
use base 'JSON::RPC::Client';
use POSIX;
use strict;

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $headers, $obj) = @_;
    my $result;


    {
	if ($uri =~ /\?/) {
	    $result = $self->_get($uri);
	}
	else {
	    Carp::croak "not hashref." unless (ref $obj eq 'HASH');
	    $result = $self->_post($uri, $headers, $obj);
	}

    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $headers, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	@$headers,
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
