use futures::StreamExt;

#[tokio::main]
async fn main() {
    let (tx, rx) = tokio::sync::mpsc::channel(1);

    let task = cpp_asio_poc::TimerTask::new(tx, 3);
    task.start();

    {
        //only take 3 messages as an example
        let rx = tokio_stream::wrappers::ReceiverStream::new(rx).take(3);
        futures::pin_mut!(rx);

        while let Some(m) = rx.next().await {
            println!("Received: {}", m.msg);
        }
    }

    println!("All messages received");
}
