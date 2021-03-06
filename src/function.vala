public class Vast.Function : Object
{
    public GI.FunctionInfo function_info { get; construct; }

    public Function (GI.FunctionInfo function_info)
    {
        base (function_info: function_info);
    }

    public unowned Array
    invokev (Array[] arrays)
        requires (arrays.length >= 2)
    {
        var in_args    = new GI.Argument[arrays.length];
        var return_arg = GI.Argument () { v_pointer = arrays[arrays.length - 1] };
        for (var i = 0; i < arrays.length; i++) {
            in_args[i] = GI.Argument () { v_pointer = arrays[i] };
        }
        try {
            _function_info.invoke (in_args, {}, return_arg);
            return (Array) return_arg.v_pointer;
        } catch (GI.InvokeError err) {
            error ("Could not call '%s.%s': %s.", _function_info.get_namespace (), _function_info.get_name (), err.message);
        }
    }

    public unowned Array
    invoke_valist (va_list list)
    {
        var args = new Array[function_info.get_n_args ()];
        for (;;) {
            unowned string name = list.arg<string?> ();
            unowned Array  arr  = list.arg<Array?>  ();
            if (name == null) {
                break;
            }
            if (arr == null) {
                error ("Expected an array after named argument '%s'.", name);
            }
            for (var i = function_info.get_n_args (); i > 0; i--) {
                var arg_info = function_info.get_arg (i - 1);
                if (name == arg_info.get_name ()) {
                    args[i - 1] = arr;
                    break;
                }
            }
        }
        return invokev (args);
    }

    public unowned Array
    invoke (...)
    {
        return invoke_valist (va_list ());
    }
}
