namespace Game.Base
{
    using log4net;
    using System;
    using System.Collections.Specialized;
    using System.Net;
    using System.Net.Sockets;
    using System.Reflection;
    using System.Threading;

    public class BaseServer
    {
        protected readonly HybridDictionary _clients;
        protected Socket _linstener;
        protected SocketAsyncEventArgs ac_event;
        private static readonly ILog log;
        private static readonly int SEND_BUFF_SIZE;

        static BaseServer()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            SEND_BUFF_SIZE = 0x4000;
        }

        public BaseServer()
        {
            this._clients = new HybridDictionary();
            this.ac_event = new SocketAsyncEventArgs();
            this.ac_event.Completed += new EventHandler<SocketAsyncEventArgs>(this.AcceptAsyncCompleted);
        }

        private void AcceptAsync()
        {
            try
            {
                if (this._linstener != null)
                {
                    SocketAsyncEventArgs e = new SocketAsyncEventArgs();
                    e.Completed += new EventHandler<SocketAsyncEventArgs>(this.AcceptAsyncCompleted);
                    this._linstener.AcceptAsync(e);
                }
            }
            catch (Exception exception)
            {
                log.Error("AcceptAsync is error!", exception);
            }
        }

        private void AcceptAsyncCompleted(object sender, SocketAsyncEventArgs e)
        {
            Socket connectedSocket = null;
            try
            {
                connectedSocket = e.AcceptSocket;
                connectedSocket.SendBufferSize = SEND_BUFF_SIZE;
                BaseClient newClient = this.GetNewClient();
                try
                {
                    if (log.IsInfoEnabled)
                    {
                        log.Info("Incoming connection from " + (connectedSocket.Connected ? connectedSocket.RemoteEndPoint.ToString() : "socket disconnected"));
                    }
                    lock (this._clients.SyncRoot)
                    {
                        this._clients.Add(newClient, newClient);
                        newClient.Disconnected += new ClientEventHandle(this.client_Disconnected);
                    }
                    newClient.Connect(connectedSocket);
                    newClient.ReceiveAsync();
                }
                catch (Exception exception)
                {
                    log.ErrorFormat("create client failed:{0}", exception);
                    newClient.Disconnect();
                }
            }
            catch
            {
                if (connectedSocket != null)
                {
                    try
                    {
                        connectedSocket.Close();
                    }
                    catch
                    {
                    }
                }
            }
            finally
            {
                e.Dispose();
                this.AcceptAsync();
            }
        }

        private void client_Disconnected(BaseClient client)
        {
            client.Disconnected -= new ClientEventHandle(this.client_Disconnected);
            this.RemoveClient(client);
        }

        public void Dispose()
        {
            this.ac_event.Dispose();
        }

        public BaseClient[] GetAllClients()
        {
            lock (this._clients.SyncRoot)
            {
                BaseClient[] array = new BaseClient[this._clients.Count];
                this._clients.Keys.CopyTo(array, 0);
                return array;
            }
        }

        protected virtual BaseClient GetNewClient()
        {
            return new BaseClient(new byte[0x2000], new byte[0x2000]);
        }

        public virtual bool InitSocket(IPAddress ip, int port)
        {
            bool flag;
            try
            {
                this._linstener = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                this._linstener.Bind(new IPEndPoint(ip, port));
                return true;
            }
            catch (Exception exception)
            {
                log.Error("InitSocket", exception);
                flag = false;
            }
            return flag;
        }

        public virtual void RemoveClient(BaseClient client)
        {
            lock (this._clients.SyncRoot)
            {
                this._clients.Remove(client);
            }
        }

        public virtual bool Start()
        {
            bool flag;
            if (this._linstener == null)
            {
                return false;
            }
            try
            {
                this._linstener.Listen(100);
                this.AcceptAsync();
                if (log.IsDebugEnabled)
                {
                    log.Debug("Server is now listening to incoming connections!");
                }
                return true;
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Start", exception);
                }
                if (this._linstener != null)
                {
                    this._linstener.Close();
                }
                flag = false;
            }
            return flag;
        }

        public virtual void Stop()
        {
            log.Debug("Stopping server! - Entering method");
            try
            {
                if (this._linstener != null)
                {
                    Socket socket = this._linstener;
                    this._linstener = null;
                    socket.Close();
                    log.Debug("Server is no longer listening for incoming connections!");
                }
            }
            catch (Exception exception)
            {
                log.Error("Stop", exception);
            }
            if (this._clients != null)
            {
                object obj2;
                Monitor.Enter(obj2 = this._clients.SyncRoot);
                try
                {
                    BaseClient[] array = new BaseClient[this._clients.Keys.Count];
                    this._clients.Keys.CopyTo(array, 0);
                    foreach (BaseClient client in array)
                    {
                        client.Disconnect();
                    }
                    log.Debug("Stopping server! - Cleaning up client list!");
                }
                catch (Exception exception2)
                {
                    log.Error("Stop", exception2);
                }
                finally
                {
                    Monitor.Exit(obj2);
                }
            }
            log.Debug("Stopping server! - End of method!");
        }

        public int ClientCount
        {
            get
            {
                return this._clients.Count;
            }
        }
    }
}
