// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go k8s.io/api/batch/v1beta1

package v1beta1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	batchv1 "k8s.io/api/batch/v1"
	"k8s.io/api/core/v1"
)

// JobTemplate describes a template for creating copies of a predefined pod.
#JobTemplate: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Defines jobs that will be created from this template.
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	template?: #JobTemplateSpec @go(Template) @protobuf(2,bytes,opt)
}

// JobTemplateSpec describes the data a Job should have when created from a template
#JobTemplateSpec: {
	// Standard object's metadata of the jobs created from this template.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Specification of the desired behavior of the job.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: batchv1.#JobSpec @go(Spec) @protobuf(2,bytes,opt)
}

// CronJob represents the configuration of a single cron job.
#CronJob: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Specification of the desired behavior of a cron job, including the schedule.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: #CronJobSpec @go(Spec) @protobuf(2,bytes,opt)

	// Current status of a cron job.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	status?: #CronJobStatus @go(Status) @protobuf(3,bytes,opt)
}

// CronJobList is a collection of cron jobs.
#CronJobList: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// items is the list of CronJobs.
	items: [...#CronJob] @go(Items,[]CronJob) @protobuf(2,bytes,rep)
}

// CronJobSpec describes how the job execution will look like and when it will actually run.
#CronJobSpec: {
	// The schedule in Cron format, see https://en.wikipedia.org/wiki/Cron.
	schedule: string @go(Schedule) @protobuf(1,bytes,opt)

	// The time zone for the given schedule, see https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
	// If not specified, this will rely on the time zone of the kube-controller-manager process.
	// ALPHA: This field is in alpha and must be enabled via the `CronJobTimeZone` feature gate.
	// +optional
	timeZone?: null | string @go(TimeZone,*string) @protobuf(8,bytes,opt)

	// Optional deadline in seconds for starting the job if it misses scheduled
	// time for any reason.  Missed jobs executions will be counted as failed ones.
	// +optional
	startingDeadlineSeconds?: null | int64 @go(StartingDeadlineSeconds,*int64) @protobuf(2,varint,opt)

	// Specifies how to treat concurrent executions of a Job.
	// Valid values are:
	// - "Allow" (default): allows CronJobs to run concurrently;
	// - "Forbid": forbids concurrent runs, skipping next run if previous run hasn't finished yet;
	// - "Replace": cancels currently running job and replaces it with a new one
	// +optional
	concurrencyPolicy?: #ConcurrencyPolicy @go(ConcurrencyPolicy) @protobuf(3,bytes,opt,casttype=ConcurrencyPolicy)

	// This flag tells the controller to suspend subsequent executions, it does
	// not apply to already started executions.  Defaults to false.
	// +optional
	suspend?: null | bool @go(Suspend,*bool) @protobuf(4,varint,opt)

	// Specifies the job that will be created when executing a CronJob.
	jobTemplate: #JobTemplateSpec @go(JobTemplate) @protobuf(5,bytes,opt)

	// The number of successful finished jobs to retain.
	// This is a pointer to distinguish between explicit zero and not specified.
	// Defaults to 3.
	// +optional
	successfulJobsHistoryLimit?: null | int32 @go(SuccessfulJobsHistoryLimit,*int32) @protobuf(6,varint,opt)

	// The number of failed finished jobs to retain.
	// This is a pointer to distinguish between explicit zero and not specified.
	// Defaults to 1.
	// +optional
	failedJobsHistoryLimit?: null | int32 @go(FailedJobsHistoryLimit,*int32) @protobuf(7,varint,opt)
}

// ConcurrencyPolicy describes how the job will be handled.
// Only one of the following concurrent policies may be specified.
// If none of the following policies is specified, the default one
// is AllowConcurrent.
#ConcurrencyPolicy: string // #enumConcurrencyPolicy

#enumConcurrencyPolicy:
	#AllowConcurrent |
	#ForbidConcurrent |
	#ReplaceConcurrent

// AllowConcurrent allows CronJobs to run concurrently.
#AllowConcurrent: #ConcurrencyPolicy & "Allow"

// ForbidConcurrent forbids concurrent runs, skipping next run if previous
// hasn't finished yet.
#ForbidConcurrent: #ConcurrencyPolicy & "Forbid"

// ReplaceConcurrent cancels currently running job and replaces it with a new one.
#ReplaceConcurrent: #ConcurrencyPolicy & "Replace"

// CronJobStatus represents the current state of a cron job.
#CronJobStatus: {
	// A list of pointers to currently running jobs.
	// +optional
	// +listType=atomic
	active?: [...v1.#ObjectReference] @go(Active,[]v1.ObjectReference) @protobuf(1,bytes,rep)

	// Information when was the last time the job was successfully scheduled.
	// +optional
	lastScheduleTime?: null | metav1.#Time @go(LastScheduleTime,*metav1.Time) @protobuf(4,bytes,opt)

	// Information when was the last time the job successfully completed.
	// +optional
	lastSuccessfulTime?: null | metav1.#Time @go(LastSuccessfulTime,*metav1.Time) @protobuf(5,bytes,opt)
}
