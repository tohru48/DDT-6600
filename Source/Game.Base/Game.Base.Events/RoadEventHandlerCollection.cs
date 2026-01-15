namespace Game.Base.Events
{
    using Game.Base;
    using log4net;
    using System;
    using System.Collections.Specialized;
    using System.Reflection;
    using System.Threading;

    public class RoadEventHandlerCollection
    {
        private static readonly ILog log;
        protected readonly HybridDictionary m_events;
        protected readonly ReaderWriterLock m_lock;
        protected const int TIMEOUT = 0xbb8;

        static RoadEventHandlerCollection()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        public RoadEventHandlerCollection()
        {
            this.m_lock = new ReaderWriterLock();
            this.m_events = new HybridDictionary();
        }

        public void AddHandler(RoadEvent e, RoadEventHandler del)
        {
            try
            {
                this.m_lock.AcquireWriterLock(0xbb8);
                try
                {
                    WeakMulticastDelegate weakDelegate = (WeakMulticastDelegate)this.m_events[e];
                    if (weakDelegate == null)
                    {
                        this.m_events[e] = new WeakMulticastDelegate(del);
                    }
                    else
                    {
                        this.m_events[e] = WeakMulticastDelegate.Combine(weakDelegate, del);
                    }
                }
                finally
                {
                    this.m_lock.ReleaseWriterLock();
                }
            }
            catch (ApplicationException exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Failed to add event handler!", exception);
                }
            }
        }

        public void AddHandlerUnique(RoadEvent e, RoadEventHandler del)
        {
            try
            {
                this.m_lock.AcquireWriterLock(0xbb8);
                try
                {
                    WeakMulticastDelegate weakDelegate = (WeakMulticastDelegate)this.m_events[e];
                    if (weakDelegate == null)
                    {
                        this.m_events[e] = new WeakMulticastDelegate(del);
                    }
                    else
                    {
                        this.m_events[e] = WeakMulticastDelegate.CombineUnique(weakDelegate, del);
                    }
                }
                finally
                {
                    this.m_lock.ReleaseWriterLock();
                }
            }
            catch (ApplicationException exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Failed to add event handler!", exception);
                }
            }
        }

        public void Notify(RoadEvent e)
        {
            this.Notify(e, null, null);
        }

        public void Notify(RoadEvent e, EventArgs args)
        {
            this.Notify(e, null, args);
        }

        public void Notify(RoadEvent e, object sender)
        {
            this.Notify(e, sender, null);
        }

        public void Notify(RoadEvent e, object sender, EventArgs eArgs)
        {
            try
            {
                WeakMulticastDelegate delegate2;
                this.m_lock.AcquireReaderLock(0xbb8);
                try
                {
                    delegate2 = (WeakMulticastDelegate)this.m_events[e];
                }
                finally
                {
                    this.m_lock.ReleaseReaderLock();
                }
                if (delegate2 != null)
                {
                    delegate2.InvokeSafe(new object[] { e, sender, eArgs });
                }
            }
            catch (ApplicationException exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Failed to notify event handler!", exception);
                }
            }
        }

        public void RemoveAllHandlers()
        {
            try
            {
                this.m_lock.AcquireWriterLock(0xbb8);
                try
                {
                    this.m_events.Clear();
                }
                finally
                {
                    this.m_lock.ReleaseWriterLock();
                }
            }
            catch (ApplicationException exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Failed to remove all event handlers!", exception);
                }
            }
        }

        public void RemoveAllHandlers(RoadEvent e)
        {
            try
            {
                this.m_lock.AcquireWriterLock(0xbb8);
                try
                {
                    this.m_events.Remove(e);
                }
                finally
                {
                    this.m_lock.ReleaseWriterLock();
                }
            }
            catch (ApplicationException exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Failed to remove event handlers!", exception);
                }
            }
        }

        public void RemoveHandler(RoadEvent e, RoadEventHandler del)
        {
            try
            {
                this.m_lock.AcquireWriterLock(0xbb8);
                try
                {
                    WeakMulticastDelegate weakDelegate = (WeakMulticastDelegate)this.m_events[e];
                    if (weakDelegate != null)
                    {
                        weakDelegate = WeakMulticastDelegate.Remove(weakDelegate, del);
                        if (weakDelegate == null)
                        {
                            this.m_events.Remove(e);
                        }
                        else
                        {
                            this.m_events[e] = weakDelegate;
                        }
                    }
                }
                finally
                {
                    this.m_lock.ReleaseWriterLock();
                }
            }
            catch (ApplicationException exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Failed to remove event handler!", exception);
                }
            }
        }
    }
}
