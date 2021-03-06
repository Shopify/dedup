#include <ruby.h>
#include <ruby/st.h>
#include <stdbool.h>

#define RHASH_AR_TABLE_MAX_SIZE SIZEOF_VALUE

static ID id_uminus;
static VALUE empty_array, empty_hash;

static VALUE deep_intern(VALUE);

typedef struct {
    bool changed;
    long index;
    VALUE *pairs;
} hash_iter_arg;

int
dedup_hash_iter_callback(VALUE key, VALUE value, VALUE arg)
{
    hash_iter_arg *iter_arg = (hash_iter_arg *)arg;

    VALUE new_key = deep_intern(key);
    iter_arg->pairs[iter_arg->index] = new_key;
    iter_arg->index++;
    iter_arg->changed |= new_key != key;

    VALUE new_value = deep_intern(value);
    iter_arg->pairs[iter_arg->index] = new_value;
    iter_arg->index++;
    iter_arg->changed |= new_value != value;

    return ST_CONTINUE;
}

static VALUE
deep_intern(VALUE data)
{
    if (RB_SPECIAL_CONST_P(data)) {
        return data;
    }

    int type = BUILTIN_TYPE(data);

    if (RB_OBJ_FROZEN(data) && (type != T_STRING || FL_TEST(data, RSTRING_FSTR))) {
        return data;
    }

    switch (type) {
      case T_STRING:
        return rb_funcall(rb_str_freeze(data), id_uminus, 0);
        break;
      case T_HASH:
        {
            long size = RHASH_SIZE(data);
            if (size == 0) {
                return empty_hash;
            }

            hash_iter_arg arg;
            arg.changed = false;
            arg.index = 0;
            arg.pairs = alloca(sizeof(VALUE) * 2 * size);
            rb_hash_foreach(data, dedup_hash_iter_callback, (VALUE)&arg);
            if (arg.changed) {
                rb_hash_clear(data);
                rb_hash_bulk_insert(arg.index, arg.pairs, data);
            }

            rb_obj_freeze(data);
        }
        break;
      case T_ARRAY:
        {
            long size = RARRAY_LEN(data);
            if (size == 0) {
                return empty_array;
            }
            for (long index = 0; index < size; index++) {
                RARRAY_ASET(data, index, deep_intern(RARRAY_AREF(data, index)));
            }
            rb_obj_freeze(data);
        }
        break;
      default:
        rb_obj_freeze(data);
    }
    return data;
}

static VALUE
dedup_deep_intern_bang(VALUE self, VALUE data)
{

    return deep_intern(data);
}

void
Init_dedup()
{
    id_uminus = rb_intern("-@");

    VALUE rb_mDedup = rb_const_get(rb_cObject, rb_intern("Dedup"));
    empty_hash = rb_const_get(rb_mDedup, rb_intern("EMPTY_HASH"));
    rb_global_variable(&empty_hash);
    empty_array = rb_const_get(rb_mDedup, rb_intern("EMPTY_ARRAY"));
    rb_global_variable(&empty_array);

    VALUE rb_mNative = rb_define_module_under(rb_mDedup, "Native");
    rb_define_method(rb_mNative, "deep_intern!", dedup_deep_intern_bang, 1);
}
