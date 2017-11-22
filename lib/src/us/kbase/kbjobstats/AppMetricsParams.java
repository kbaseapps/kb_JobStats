
package us.kbase.kbjobstats;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import us.kbase.common.service.Tuple2;


/**
 * <p>Original spec-file type: AppMetricsParams</p>
 * <pre>
 * job_stage has one of 'created', 'started', 'complete', 'canceled', 'error' or 'all' (default)
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "user_ids",
    "time_range",
    "job_stage"
})
public class AppMetricsParams {

    @JsonProperty("user_ids")
    private List<String> userIds;
    @JsonProperty("time_range")
    private Tuple2 <String, String> timeRange;
    @JsonProperty("job_stage")
    private java.lang.String jobStage;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("user_ids")
    public List<String> getUserIds() {
        return userIds;
    }

    @JsonProperty("user_ids")
    public void setUserIds(List<String> userIds) {
        this.userIds = userIds;
    }

    public AppMetricsParams withUserIds(List<String> userIds) {
        this.userIds = userIds;
        return this;
    }

    @JsonProperty("time_range")
    public Tuple2 <String, String> getTimeRange() {
        return timeRange;
    }

    @JsonProperty("time_range")
    public void setTimeRange(Tuple2 <String, String> timeRange) {
        this.timeRange = timeRange;
    }

    public AppMetricsParams withTimeRange(Tuple2 <String, String> timeRange) {
        this.timeRange = timeRange;
        return this;
    }

    @JsonProperty("job_stage")
    public java.lang.String getJobStage() {
        return jobStage;
    }

    @JsonProperty("job_stage")
    public void setJobStage(java.lang.String jobStage) {
        this.jobStage = jobStage;
    }

    public AppMetricsParams withJobStage(java.lang.String jobStage) {
        this.jobStage = jobStage;
        return this;
    }

    @JsonAnyGetter
    public Map<java.lang.String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(java.lang.String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public java.lang.String toString() {
        return ((((((((("AppMetricsParams"+" [userIds=")+ userIds)+", timeRange=")+ timeRange)+", jobStage=")+ jobStage)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
