cc := gcc

run: app-dynamic app-semi-static app-static
	-LD_LIBRARY_PATH=lib/shared ldd app-dynamic app-semi-static app-static
	-LD_LIBRARY_PATH=lib/shared ./app-dynamic
	-./app-semi-static
	-./app-static

app-dynamic: lib/shared/libanswer.so
	$(cc) -o app-dynamic app.c -Ianswer -lanswer -Llib/shared

app-semi-static: lib/static/libanswer.a
	$(cc) -o app-semi-static app.c -Ianswer -lanswer -Llib/static

app-static: lib/static/libanswer.a
	$(cc) -static -o app-static app.c -Ianswer -lanswer -Llib/static

lib/shared/lib%.so:
	cd $* && $(cc) -fPIC -c $*.c && $(cc) -shared -o lib$*.so $*.o
	mkdir -p lib/shared
	mv $*/lib$*.so lib/shared

lib/static/lib%.a:
	cd $* && $(cc) -c $*.c && ar cr lib$*.a $*.o && ranlib lib$*.a
	mkdir -p lib/static
	mv $*/lib$*.a lib/static
