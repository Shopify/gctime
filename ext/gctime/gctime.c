#include <ruby.h>
#include <ruby/debug.h>
#include <stdbool.h>
#include <errno.h>
#include <time.h>
#include <stdlib.h>

static uint64_t total_time_ns = 0;
static VALUE tracepoint = Qnil;
static struct timespec gc_entered_at;

inline void
gctime_get(struct timespec *time)
{
    if (clock_gettime(CLOCK_MONOTONIC, time) == -1) {
        rb_sys_fail("clock_gettime");
    }
}

static void
gctime_hook(VALUE tpval, void *data)
{
    switch (rb_tracearg_event_flag(rb_tracearg_from_tracepoint(tpval))) {
        case RUBY_INTERNAL_EVENT_GC_ENTER: {
            gctime_get(&gc_entered_at);
        }
        break;

        case RUBY_INTERNAL_EVENT_GC_EXIT: {
            struct timespec gc_exited_at;
            gctime_get(&gc_exited_at);
            total_time_ns += (gc_exited_at.tv_nsec - gc_entered_at.tv_nsec);
            total_time_ns += (gc_exited_at.tv_sec - gc_entered_at.tv_sec) * 1000000000;
        }
        break;
    }
}

static VALUE
gctime_rb_gc_total_time(VALUE klass)
{
    return ULL2NUM(total_time_ns);
}

static VALUE
gctime_rb_time_ms(VALUE klass)
{
    return ULL2NUM(total_time_ns / 1000000);
}

static VALUE
gctime_rb_measure_total_time(VALUE klass)
{
    if (NIL_P(tracepoint)) return Qfalse;
    return rb_tracepoint_enabled_p(tracepoint);
}

static VALUE
gctime_rb_measure_total_time_set(VALUE klass, VALUE enabled)
{
    if (RTEST(enabled)) {
        if (NIL_P(tracepoint)) {
            tracepoint = rb_tracepoint_new(
                0,
                RUBY_INTERNAL_EVENT_GC_ENTER | RUBY_INTERNAL_EVENT_GC_EXIT,
                gctime_hook,
                (void *) NULL
            );
        }
        rb_tracepoint_enable(tracepoint);
    } else {
        if (!NIL_P(tracepoint)) {
            rb_tracepoint_disable(tracepoint);
        }
    }
    return enabled;
}

void
Init_gctime()
{
    rb_global_variable(&tracepoint);

    VALUE mGC = rb_const_get(rb_cObject, rb_intern("GC"));
    rb_define_module_function(mGC, "total_time", gctime_rb_gc_total_time, 0);
    rb_define_module_function(mGC, "measure_total_time", gctime_rb_measure_total_time, 0);
    rb_define_module_function(mGC, "measure_total_time=", gctime_rb_measure_total_time_set, 1);

    VALUE mGCTime = rb_const_get(rb_cObject, rb_intern("GCTime"));
    rb_define_module_function(mGCTime, "_time_ms", gctime_rb_time_ms, 0);
}
