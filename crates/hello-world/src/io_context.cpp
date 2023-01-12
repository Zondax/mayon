#include "hello-world/include/io_context.h"

static asio::io_context io_context;

asio::io_context &get_io_instance()
{

    static bool once = [](){

        std::thread t([](){
                // this work thing make io_context unusable later?
                asio::executor_work_guard<asio::io_context::executor_type> work = asio::make_work_guard(io_context);
                io_context.run(); // Might this call invalidate any usage of io_context?
        });

        t.detach();
        return true;
    } ();

    return io_context;
}
