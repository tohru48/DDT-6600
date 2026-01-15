// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.NewTrainingBoss25002
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class NewTrainingBoss25002 : ABrain
  {
    protected Player m_targer;
    private static Random random = new Random();
    private static string[] listChat = new string[3]
    {
      "Ý! Bị đánh đến vầy sao！",
      "Chỉ là một đứa nhóc mà mạnh vậy sao?!",
      "Ta đến báo thù đây, cẩn thận！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
      if (!this.m_body.IsSay)
        return;
      this.m_body.Say(NewTrainingBoss25002.GetOneChat(), 0, this.Game.Random.Next(0, 5000));
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      this.Beating();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void MoveToPlayer(Player player)
    {
      int num1 = (int) player.Distance(this.Body.X, this.Body.Y);
      int num2 = this.Game.Random.Next(((SimpleBoss) this.Body).NpcInfo.MoveMin, ((SimpleBoss) this.Body).NpcInfo.MoveMax);
      if (num1 <= 97)
        return;
      int num3 = num1 <= ((SimpleBoss) this.Body).NpcInfo.MoveMax ? num1 - 90 : num2;
      if (player.Y < 420 && player.X < 210)
      {
        if (this.Body.Y > 420)
          this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "walk", 1200, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
        else if (player.X > this.Body.X)
          this.Body.MoveTo(this.Body.X + num3, this.Body.Y, "walk", 1200, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
        else
          this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "walk", 1200, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
      }
      else if (this.Body.Y < 420)
      {
        if (this.Body.X + num3 > 200)
          this.Body.MoveTo(200, this.Body.Y, "walk", 1200, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.Fall));
      }
      else if (player.X > this.Body.X)
        this.Body.MoveTo(this.Body.X + num3, this.Body.Y, "walk", 1200, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
      else
        this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "walk", 1200, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
    }

    public void MoveBeat() => this.Body.Beat((Living) this.m_targer, "beatA", 100, 0, 200, 1, 1);

    public void Beating()
    {
      if (this.m_targer == null || this.Body.Beat((Living) this.m_targer, "beatA", 100, 0, 200, 1, 1))
        return;
      this.MoveToPlayer(this.m_targer);
    }

    public void Fall()
    {
      this.Body.FallFrom(this.Body.X, this.Body.Y + 240, (string) null, 200, 0, 12, new LivingCallBack(this.Beating));
    }

    public static string GetOneChat()
    {
      int index = NewTrainingBoss25002.random.Next(0, NewTrainingBoss25002.listChat.Length);
      return NewTrainingBoss25002.listChat[index];
    }

    public static void LivingSay(List<Living> livings)
    {
      if (livings == null || livings.Count == 0)
        return;
      int count = livings.Count;
      foreach (Living living in livings)
        living.IsSay = false;
      int length = count > 5 ? (count <= 5 || count > 10 ? NewTrainingBoss25002.random.Next(1, 4) : NewTrainingBoss25002.random.Next(1, 3)) : NewTrainingBoss25002.random.Next(0, 2);
      if (length <= 0)
        return;
      int[] numArray = new int[length];
      int num = 0;
      while (num < length)
      {
        int index = NewTrainingBoss25002.random.Next(0, count);
        if (!livings[index].IsSay)
        {
          livings[index].IsSay = true;
          int delay = NewTrainingBoss25002.random.Next(0, 5000);
          livings[index].Say(SimpleNpcAi.GetOneChat(), 0, delay);
          ++num;
        }
      }
    }
  }
}
