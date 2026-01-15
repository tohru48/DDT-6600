namespace Game.Base
{
    using log4net;
    using System;
    using System.Reflection;
    using System.Text;

    public class WeakMulticastDelegate
    {
        private static readonly ILog log;
        private MethodInfo method;
        private WeakMulticastDelegate prev;
        private WeakReference weakRef;

        static WeakMulticastDelegate()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        public WeakMulticastDelegate(Delegate realDelegate)
        {
            if (realDelegate.Target != null)
            {
                this.weakRef = new WeakRef(realDelegate.Target);
            }
            this.method = realDelegate.Method;
        }

        private WeakMulticastDelegate Combine(Delegate realDelegate)
        {
            WeakMulticastDelegate delegate2 = new WeakMulticastDelegate(realDelegate)
            {
                prev = this.prev
            };
            this.prev = delegate2;
            return this;
        }

        public static WeakMulticastDelegate Combine(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
            if (realDelegate == null)
            {
                return null;
            }
            if (weakDelegate != null)
            {
                return weakDelegate.Combine(realDelegate);
            }
            return new WeakMulticastDelegate(realDelegate);
        }

        private WeakMulticastDelegate CombineUnique(Delegate realDelegate)
        {
            bool flag;
            if (!(flag = this.Equals(realDelegate)) && (this.prev != null))
            {
                for (WeakMulticastDelegate delegate2 = this.prev; !flag; delegate2 = delegate2.prev)
                {
                    if (delegate2 == null)
                    {
                        break;
                    }
                    if (delegate2.Equals(realDelegate))
                    {
                        flag = true;
                    }
                }
            }
            if (!flag)
            {
                return this.Combine(realDelegate);
            }
            return this;
        }

        public static WeakMulticastDelegate CombineUnique(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
            if (realDelegate == null)
            {
                return null;
            }
            if (weakDelegate != null)
            {
                return weakDelegate.CombineUnique(realDelegate);
            }
            return new WeakMulticastDelegate(realDelegate);
        }

        public string Dump()
        {
            StringBuilder builder = new StringBuilder();
            WeakMulticastDelegate prev = this;
            int num = 0;
            while (prev != null)
            {
                num++;
                if (prev.weakRef == null)
                {
                    builder.Append("\t");
                    builder.Append(num);
                    builder.Append(") ");
                    builder.Append(prev.method.Name);
                    builder.Append(Environment.NewLine);
                }
                else if (prev.weakRef.IsAlive)
                {
                    builder.Append("\t");
                    builder.Append(num);
                    builder.Append(") ");
                    builder.Append(prev.weakRef.Target);
                    builder.Append(".");
                    builder.Append(prev.method.Name);
                    builder.Append(Environment.NewLine);
                }
                else
                {
                    builder.Append("\t");
                    builder.Append(num);
                    builder.Append(") INVALID.");
                    builder.Append(prev.method.Name);
                    builder.Append(Environment.NewLine);
                }
                prev = prev.prev;
            }
            return builder.ToString();
        }

        protected bool Equals(Delegate realDelegate)
        {
            if (this.weakRef == null)
            {
                return ((realDelegate.Target == null) && (this.method == realDelegate.Method));
            }
            return ((this.weakRef.Target == realDelegate.Target) && (this.method == realDelegate.Method));
        }

        public void Invoke(object[] args)
        {
            for (WeakMulticastDelegate delegate2 = this; delegate2 != null; delegate2 = delegate2.prev)
            {
                int tickCount = Environment.TickCount;
                if (delegate2.weakRef == null)
                {
                    delegate2.method.Invoke(null, args);
                }
                else if (delegate2.weakRef.IsAlive)
                {
                    delegate2.method.Invoke(delegate2.weakRef.Target, args);
                }
                if (((Environment.TickCount - tickCount) > 500) && log.IsWarnEnabled)
                {
                    log.Warn(string.Concat(new object[] { "Invoke took ", Environment.TickCount - tickCount, "ms! ", delegate2.ToString() }));
                }
            }
        }

        public void InvokeSafe(object[] args)
        {
            for (WeakMulticastDelegate delegate2 = this; delegate2 != null; delegate2 = delegate2.prev)
            {
                int tickCount = Environment.TickCount;
                try
                {
                    if (delegate2.weakRef == null)
                    {
                        delegate2.method.Invoke(null, args);
                    }
                    else if (delegate2.weakRef.IsAlive)
                    {
                        delegate2.method.Invoke(delegate2.weakRef.Target, args);
                    }
                }
                catch (Exception exception)
                {
                    if (log.IsErrorEnabled)
                    {
                        log.Error("InvokeSafe", exception);
                    }
                }
                if (((Environment.TickCount - tickCount) > 500) && log.IsWarnEnabled)
                {
                    log.Warn(string.Concat(new object[] { "InvokeSafe took ", Environment.TickCount - tickCount, "ms! ", delegate2.ToString() }));
                }
            }
        }

        public static WeakMulticastDelegate operator +(WeakMulticastDelegate d, Delegate realD)
        {
            return Combine(d, realD);
        }

        public static WeakMulticastDelegate operator -(WeakMulticastDelegate d, Delegate realD)
        {
            return Remove(d, realD);
        }

        private WeakMulticastDelegate Remove(Delegate realDelegate)
        {
            if (this.Equals(realDelegate))
            {
                return this.prev;
            }
            WeakMulticastDelegate prev = this.prev;
            WeakMulticastDelegate delegate3 = this;
            while (prev != null)
            {
                if (prev.Equals(realDelegate))
                {
                    delegate3.prev = prev.prev;
                    prev.prev = null;
                    break;
                }
                delegate3 = prev;
                prev = prev.prev;
            }
            return this;
        }

        public static WeakMulticastDelegate Remove(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
            if ((realDelegate != null) && (weakDelegate != null))
            {
                return weakDelegate.Remove(realDelegate);
            }
            return null;
        }

        public override string ToString()
        {
            Type declaringType = null;
            if (this.method != null)
            {
                declaringType = this.method.DeclaringType;
            }
            object target = null;
            if ((this.weakRef != null) && this.weakRef.IsAlive)
            {
                target = this.weakRef.Target;
            }
            return new StringBuilder(0x40).Append("method: ").Append((declaringType == null) ? "(null)" : declaringType.FullName).Append('.').Append((this.method == null) ? "(null)" : this.method.Name).Append(" target: ").Append((target == null) ? "null" : target.ToString()).ToString();
        }
    }
}
