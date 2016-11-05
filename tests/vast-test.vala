using GLib;
using Vast;

int main (string[] args) {
    Test.init (ref args);

    Test.add_func ("/array", () => {
        message("hello");
        var a = new Vast.Array<double?>.full(sizeof (double), {10});
        message("a = %s", a.to_string());
        var b = new Vast.Array<double?>.full(sizeof (double), {10}, null, a, a.data);
        message("b = %s", b.to_string());

        for(var i = 0; i < 10; i ++) {
            a.set_scalar({i}, (double) i);
            assert (i == a.get_scalar ({i}));
        }

        for(var i = 0; i < 10; i ++) {
            assert (i == a.get_scalar ({i}));
            assert (i == b.get_scalar ({i}));
        }

        // negative index
        for(var i = -1; i > -10; i--) {
            assert (10 + i == a.get_scalar ({i}));
            assert (10 + i == b.get_scalar ({i}));
        }

        var iter = a.iterator();
        while(iter.next()) {
            message("%g", iter.get());
            iter.set((double) 0);
            message("%g", iter.get());
        }
    });

    Test.add_func ("/array/negative_indexing", () => {
        var a = new Vast.Array<double?>.full(sizeof (double), {10, 20});

        for(var i = 0; i < 10; i ++) {
            for (var j = 0; j < 20; j++) {
                a.set_scalar({i, j}, (double) i * j);
            }
        }

        // negative index
        for(var i = -1; i > -10; i--) {
            assert (10 + i == a.get_scalar ({i, 1}));
        }

        for(var j = -1; j > -20; j--) {
            assert (20 + j == a.get_scalar ({1, j}));
        }

        // diagonal negative indexing
        for (var i = -1, j = -1; i > -10 && j > -10; i-- + j--) {
            assert ((10 + i) * (20 + j) == a.get_scalar ({i, j}));
        }
    });

    return Test.run ();
}
