unit qworker;
{$I 'qdac.inc'}

interface

// �ú�����Ƿ�����QMapSymbols��Ԫ����ȡ�������ƣ��������ȡ�������������ƣ���ֻ���ǵ�ַ
{$IFDEF MSWINDOWS}
{ .$DEFINE USE_MAP_SYMBOLS }
{ .$DEFINE DEBUGOUT }
{$ENDIF}
// ���߳���̫��ʱTQSimpleLock��������������Ŀ��������������ٽ磬������ʱ����ʹ��
{ .$DEFINE QWORKER_SIMPLE_LOCK }
// ��ֹ�����򵼳�DLLʹ�õ�ͬ���ӿڣ���ʱϵͳ�������£�
// Windowsƽ̨��:����һ�����ش��ڣ����ҽ�WakeMainThread
// ����ƽ̨������һ��20ms��Timer����ʱִ�����߳���ҵ,�ɴ˻����һ�����ӳ٣�����������ƽ̨���Ƽ���ֹ
{$IFDEF MSWINDOWS}
{$DEFINE DISABLE_HOST_EXPORTS}
{$ELSE}
{ .$DEFINE DISABLE_HOST_EXPORTS }
{$ENDIF
{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ�����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�JSON����������QDAC��Ŀ�е�QJSON����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á������t���ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}
{$REGION '�޶���־'}
{ �޶���־
  2022-03-13
  ==========
  + �޸ļƻ�����ĵ��ȵ� TStaticThread���Ա�����������ҵ��Ӱ��

  2018.10.20
  ==========
  * ͳһ��������������������һ�£����Ǳ�� TMehtod.Data Ϊ -1
  * ������ WaitRunningDone Ϊ false ʱû�������������е���ҵ�����⣨��ʢ�Իͱ��棩
  + Clear ���������˼�������
  2017.5.8
  ==========
  * �޶��� DLL �����߳���ҵ�����޷�ִ�е�����
  * �޶��˵��� Clear ������ҵ��Ͷ���¼ƻ�������ҵ�޷�ִ�е����⣨�����ٷʱ��棩
  2017.1.10
  ==========
  * �޶����ӳ��ظ���ҵ�޷�ͨ����ҵ������ AJob.IsTerminated ֹͣ�����⣨��ľ���棩

  2016.11.15
  ==========
  * ������ClearSingleJob/ClearSingleJobs �����ظ���ҵʱû����ȷ�����ҵ״̬������(����Ϻ�ʱ���)
  * ������WaitRunningDoneû�еȴ���ҵ������ɾ��˳������⣨MLSkin���棩

  2016.10.11
  ==========
  * �������������������� WaitSignal ֱ���˳������⣨��ľ���棩

  2016.7.14
  ==========
  * �޸����ź���ҵ������������߰�ID����ʱ��Ч��
  * �������ź���ҵ�������ɾ������⣨MLSkin���棩
  2016.7.6
  ==========
  * ������ SignalIdByName �������㷨�߼�������ɿ����޷�������Ӧ���ź���ҵ������
  + �Ż��ź�ͨ�����Ʒ��ʵ��߼�����߰��ź����Ʒ���ʱ���ٶ�

  2016.6.24
  ==========
  * �޸��� Delay �Ķ�����ظ���ҵ�Ĵ����߼���������ض�������޷���ȷ���������⣨����Ϻ�ʱ��棩
  * �������ź���ҵ�����ض������³���AV���������

  2016.6.23
  ==========
  * ������ Delay ���ظ���ҵ����ʱ�п���δ�����ɹ������⣨����Ϻ�ʱ��棩
  + �ź���ҵ�����������ڴ���˳����ź���ҵ֧�֣�ͨ�� SignalQueue ���Ե� Post �����ṩ֧�֣�MLSkin ���飩

  2016.5.3
  ==========
  * �ƻ�������ҵ�ļƻ�������ĩ��ִ��ʱ��ļ�¼
  * ������ SetMaxWorkers �м��MinWorkersֵ��������⣨D7 ���棩
  2016.5.2
  ==========
  * ������ RunInMainThread ȫ�ֺ�������δ��ȷ���ݵ����⣨��ͭʱ�����棩
  2016.4.21
  ==========
  * TQForJobs �Ĺ��캯���� AFreeType ����Ĭ��ֵ
  + TQForJobs ���� Run �������Ա㵥������
  * �޸��� Delay �������´�ִ��ʱ�����ʱ��
  * ������ Delay ����û�и�����ҵͳ����Ϣ������
  * ������ Plan ��������ҵ�û�ָ�����������ͷŷ�ʽû����ȷ����������
  2016.4.11
  =========
  * ������ EnumJobStates �� PeekJobState ���ص���������ҵ״̬����ȷ�����⣨�ഺ���棩
  * �޸��� At ��������ʱ������Ϊ��������Ϊ����Ϊ����������ʱ�������е����ڲ��֣��ഺ���棩

  2016.3.16
  ==========
  * �������ض������£����й����߱�ȫ����͵����⣨LakeView���棩

  2016.2.23
  ==========
  * ������ WaitJob ���ض������£������ҵ���ᱻ�����߼�ʱ���õ����⣨�ɺƱ��棩
  2016.1.23
  ==========
  * �� MsgWaitForEvent ��������
  2016.1.8
  ==========
  * ������ WaitJob ѭ����ͨ��ҵʱ��δ��ȷ����AJob.Next��һ����ҵ�����⣨С�챨�棩
  2015.11.20
  ==========
  + ���� WaitJob ���ȴ�һ����ͨ��ҵ��ʱ����ɣ���ľ���飩
  * �޸��� TQJob �Ľṹ������ Source Ӱ���ظ���ҵ�� Interval �� FirstDelay �������󶡱��棩
  2015.11.6
  =========
  * �������������� ClearJobState �����⣬��ɰ���������ҵ��������ʱ���˳�ʱ�ڴ�й¶�����⣨��ľ���棩
  2015.8.27
  =========
  * ������ TQJobGroup.Add ����������֧�ְ汾������

  2015.8.11
  =========
  * �����˼ƻ�������ҵ��ʱʧЧʱ���������㷨����
  * �ƻ�������ҵ��֧�ָ����ӵı���ʽ��������ߵ��루��ľ�ṩ������ϣ�
  2015.7.27
  =========
  * ������ SetMaxWorkers ʱ��ʱ����ҵ����û�и��ű��������

  2015.7.3
  =========
  * �������ܴμ��㺯����������ܴμ��������Ч�����⣨�ഺ���棩
  2015.6.16
  ==========
  * ������TQJobGroup.Cancelʱ����Ͷ�ĵ���ҵû����ȷȡ�������⣨�˼����棩
  * �޸�TQJobGroup.Cancelȡ����ҵʱ��WaitFor�Ľ��ΪwrAbandoned�����û�б�ȡ�������������أ�
  2015.6.15
  =========
  * �ƻ���ҵ��������ظ���ҵĬ�ϲ��ٳ�ʼ�ʹ�����ֻ�з���ƻ������Żᴴ��
  * �ƻ���ҵ���ʱ����޸ĳɰ����Ӷ��루������ÿ���ӵ�0��0���봥����
  2015.5.13
  =========
  * ������ LookupIdleWorker ����Ͷ����������ʱ������δ��������Worker�����������⣨LakeView���棩
  2015.4.19
  =========
  * �������ϴ��޸Ľ���㷨���ÿ��һ��ʱ��CPUռ���ʻ����������⣨�ֺ뱨�棩

  2015.4.7
  =========
  + TQJobExtData ����һ���������չ���Է��㴫�ݶ������
  2015.4.6
  =========
  + TQJob ���� Handle ���ԣ��������Լ���Ӧ�ľ��ʵ����ַ���ֺ롢����С�׽��飩
  * ClearSingleJob ��������ʱ�Ƿ�ȴ�����ִ�й�����ɵĴ���
  * EnumJobState ����Լƻ���ҵ��ִ��
  * �޸ľ����־���壬0,1,2,3�ֱ��Ӧ����ҵ���ظ���ҵ���ź���ҵ�ͼƻ���ҵ

  2015.4.2
  =========
  * ������ GetTimeTick ���������ɶ�ʱ��ҵ����ʧ�ܵ����⣨���±��棩
  + ���� Plan ����֧�ּƻ��������͵���ҵ�������СΪ1���ӣ�

  2015.3.9
  =========
  * ������ TQRepeatJobs.DoTimeCompare �Ƚ�ʱ��ʱ�������������ض�Ӧ�û����³��������⣨�����������棩
  2015.2.26
  =========
  * ���������������� 2007 ���޷���������⣨My Spring ���棩
  * ���������������� Android / iOS / OSX ���޷���������⣨�����ٷʱ��棩
  2015.2.24
  =========
  + TQJobGroup ���� Insert �������ڲ�����ҵ���ض�λ�ã�â���������
  2015.2.9
  =========
  * �������ƶ�ƽ̨����ҵ����Ϊ��������������£��ظ��ͷ���������ָ�������
  2015.2.3
  =========
  * ��������ʹ�� FastMM4 ������ FullDebugInIDE ģʽʱ���˳�ʱ���������⣨ԡ���������棬�ഺȷ�ϣ�
  * ������ OnError �������Ƿ���������

  2015.1.29
  =========
  * ������ TQSimpleJobs.Clear �����һ����������Ҫʱ�㷨�߼����������⣨KEN���棩
  * ���������ض��龳���޷���ʱ�����ظ���ҵ������

  2015.1.28
  =========
  * ������ Post / At �ظ���ҵʱ������ظ���� AInterval ����ֵС�� 0 ʱ���������ظ�������

  2015.1.26
  =========
  * ������ TQJobGroup.Cancel ȡ����ҵʱ������ɵȴ�ֱ����ʱ�����⣨�����ٷʱ��棩
  2015.1.15
  =========
  + TQJobGroup ����ȫ�ֺ���������������֧��

  2015.1.12
  =========
  + �������� PeekJobState ����ȡ������ҵ��״̬��Ϣ
  + �������� EnumJobStates ����ȡ������ҵ��״̬��Ϣ

  2015.1.9
  =========
  * �������� 2007�ļ�������,Clear(PIntPtr,ACount)��Ϊ��ClearJobs

  2014.12.25
  ==========
  * QWorker��Clear(AHandle:IntPtr)������Ϊ��ClearSingleJob���Խ��������Delphi�б������⣨���壩

  2014.12.24
  ==========
  + TQWorkers.Clear�����µ����أ�����һ�������������ҵ����������У������ʹ�ã�lionet����)

  2014.12.3
  ==========
  * TQJobGroup.Cancel�����Ƿ�ȴ��������е���ҵ�����������Ա�������ҵ��ֱ��ȡ��
  ����������ȫ����ҵʱ��ѭ�������⣨�ֺ룩

  2014.11.25
  ==========
  * ������WaitSignal���������ض�����£������ӳ���ҵʱδ����ȷ����������

  2014.11.24
  ==========
  * �������ƶ�ƽ̨�£�ADataΪ����ʱ������ϵͳ�Զ��������ü�������ɶ�����Զ��ͷŵ����⣨�ֺ뱨�棩
  2014.11.13
  ==========
  + TQJobGroup����FreeAfterDone���ԣ�������ΪTrueʱ��������ҵ��ɺ��Զ��ͷŶ����������ֺ뽨�飩
  * ������TQJobGroup�˳�ʱ�����ڿ�������������
  * �����˷�����ҵδȫ������˳�ʱ��û���Զ��ͷ�����ڴ�й¶�����⣨�ֺ뱨�棩

  2014.11.11
  ==========
  * �޸���ҵ���ؾ������ΪIntPtr��������Int64����32λƽ̨�����Կ�һЩ������С�ס��ֺ룩

  2014.11.8
  ==========
  * ������LongtimeJob�ڷ���ֵΪ0ʱ����ҵ����Push��������⣨����С�ף�
  * �������ظ���ҵ������չ����ʱ���״�ִ������ҵ��ᱻ�ͷŵ����⣨����С�ף�
  * ������Assignʱ�������������ü���������
  * For������TQWorkersʵ����ʵ��һ�������汾ֱ�ӵ���TQForJobs.For��Ӧ�İ汾
  2014.10.30
  ==========
  * �޸���������ѡ��Լ���2007

  2014.10.28
  ==========
  * ������������ѡ��Լ����ƶ�ƽ̨(�ֺ뱨��)

  2014.10.27
  ===========
  * �޸���ҵͶ�ģ�Post��At��Delay��LongtimeJob�ȣ��ķ���ֵΪInt64���͵ľ��������Ψһ��
  ��һ����ҵ����������Ҫʱ����Clear(���ֵ)�������Ӧ����ҵ����л�ֺ��������
  * TQJobExtDataĬ��ʵ���˸���������͵�֧�֣���л�ֺ��������

  2014.10.26
  ==========
  + ����������ҵ���Զ�����չ�������Ͷ���TQJobExtData�Ա�ָ����ҵ���ͷŹ�������
  jdfFreeAsC1~jdfFreeAsC6�����ƣ���ϸ˵���ο� http://www.qdac.cc/?p=1018 ˵��
  ����л�ֺ��������

  2014.10.21
  ==========
  * Ĭ�����ƶ�ƽ̨��֧��QMapSymbols���ֺ뱨�棩
  * �������ƶ�ƽ̨������TStaticThread���ȼ�ʧ�ܵ����⣨�ֺ뱨��)

  2014.10.16
  ===========
  * ���������ڳ�ʼ��˳���ԭ�����TStaticThread.CheckNeed���������ڳ�������ʱ���������⣨�ഺ����)
  2014.10.14
  ===========
  * ���������ض�������˳�����TStaticThread����Workers.FSimpleJobs��Ч��ַ��ɵ�����(����С���޸�)
  2014.10.11
  ==========
  * ������TQJobGroup��Ͷ����ҵ��Prepare/Runʱ���ظ�Ͷ����ɳ��������⣨����С�ױ��棩
  һ���Ƽ�����˳��ΪPrepare/Add/Run/Wait��
  * ������Forѭ��ʱ��������������

  2014.10.8
  =========
  * ������TQJobGroup.Count������Ч�����⣨�嶾���棩
  * ����������ҵ��ʱ���ӣ���Prepare/Run��ʱδ��ȷִ�е����⣨�嶾���棩
  * ����������TSystemTimes�����ͻ��ɺ����޷���XE3��XE4���޷���������⣨���Ա��棩

  2014.9.29
  =========
  + EnumWorkerStatusʱ�������˹��������һ�δ�����ҵ��ʱ�����
  * ���������ض�����³�ʱ�Զ���͹����߻��Ʋ���Ч�����⣨����С�ױ��棩
  2014.9.26
  =========
  + �����̨��CPU�����ʵļ�飬��CPUռ���ʽϵ�ʱ������Ҫ������������ҵʱ�������¹�����
  + ����EnumWorkerStatus������ö�ٸ�����ҵ��״̬

  2014.9.23
  =========
  * ������δ�ﵽ�������߳����ޣ����Ѵ����Ĺ����߶��ڹ�����ʱ������ɵ��ӳ�����
  2014.9.14
  =========
  + ����Forѭ��������ҵ֧�֣����ʷ�ʽΪTQForJobs.For(...)
  * �޸�TQJobProc/TQJobProcA/TQJobProcG��д�����Ա�������Ķ�
  * ������TQJobGroup.MsgWaitForʱ����Clear����ʱ���Ǵ��ݲ���������

  2014.9.12
  =========
  * �����˶��ͬһʱ��㲢�����ظ���ҵʱ���ܻ����������⣨���������СҶ���棩

  2014.9.10
  =========
  * ������At�������������ʱ���ʱ���㷨����(����С�ױ��沢������

  2014.9.9
  ========
  * �����˹���������IsIdle����첽���Ͷ�ĵĶ����ҵ���ܱ�����ִ�е����⣨����С�ױ��棩
  * ������ͬʱ��������ҵʱ��HasJobRunning����ֻ�жϵ�һ����ҵ�����о��˳����
  ����ʱ����������⣨����С�ױ��棩

  2014.9.1
  =========
  * jdfFreeAsRecord����ΪjdfFreeAsSimpleRecord������ʾ�û����������Զ��ͷŵļ�¼ֻ
  �����ڼ����ͣ�����Ǹ��Ӽ�¼���͵��ͷţ���ʹ��jdfFreeAsC1~jdfFreeAsC6��Ȼ����
  �û��Լ�ȥ��ӦOnCustomFreeData�¼�����(��лqsl�Ͱ�ľ)���ο�Demo�︴�������ͷŵ�
  ���ӡ�
  2014.8.30
  =========
  * �����˹��������ж�ʱ��ҵʱδ����ȷ��ͻָ����������������������⣨����С�ױ��棩

  2014.8.29
  =========
  * ������WaitSignal�ȴ���ʱʱ���������ʹ�����ɵȴ���ʱʱ�䲻�ԵĴ���(����СҶ����)
  2014.8.24
  =========
  * �޸��˵����㷨�����ԭ��FBusyCount���������

  2014.8.22
  =========
  * �Ż����ض��߸��ػ����£�ֱ��Ͷ����ҵ�����ٶȣ���л����С��)
  * ������FMX��Win32/Win64�ļ�������

  2014.8.21
  =========
  * ������TQJobGroupû����ȷ����������ʱ���̵����⣨����С�ױ��棩
  + ��ҵ���ӵ�Data�ͷŷ�ʽ����jdfFreeAsC1~jdfFreeAsC6�Ա��ϲ��Լ�����Data��Ա���ݵ��Զ��ͷ�
  + ����OnCustomFreeData�¼��������ϲ��Լ�����Data��Ա�Ķ����ͷ�����

  2014.8.19
  =========
  * ������TQJob.Synchronize����inline���������2007���޷���ȷ���������
  * ��������Ŀ���ƶ�ƽ̨���������
  2014.8.18
  =========
  * �����˺ϲ��������LongTimeJobͶ���������ƴ��������(־�ı��棩
  * ���������������TQJobGroup.Run������ʱ���ó���������
  + TQJobGroup����MsgWaitFor�������Ա������߳��еȴ������������߳�(�����ٷʲ�����֤)
  + TQJob����Synchronize������ʵ���Ϲ�������TThread.Synchronize����(�����ٷʲ�����֤)

  2014.8.17
  =========
  * �Ľ����ҿ����̻߳��ƣ��Ա��ⲻ��Ҫ��������л����С�׺�Ц���쳾)
  * �ϲ����룬�Լ����ظ�����������л����С�ף�
  * ������Wait�����ӿڣ�AData��AFreeType������ȡ������Ϊ���źŴ���ʱ������ز���
  * TQJobGroup.AfterDone��Ϊ���������ʱ�����жϻ�ʱʱ��Ȼ����
  + TQJobGroup.Add����������AFreeType����
  + TQJobGroup.Run�������볬ʱ���ã�����ָ����ʱ�������δִ����ɣ�����ֹ����ִ��(Bug��û����ע��δ���׸㶨)
  + TQJobGroup.Cancel��������ȡ��δִ�е���ҵִ��

  2014.8.14
  ==========
  * �ο�����С�׵Ľ��飬�޸�Assign������ͬʱTQJobHelper�Ķ�����Ը�Ϊʹ��ͬһ������ʵ��
  * ��������Delphi2007�ϱ��������(����С�ױ��沢�ṩ�޸�)
  2014.8.12
  ==========
  * ������TQJob.Assign�������Ǹ���WorkerProcA��Ա������
  2014.8.8
  ==========
  * �����������߳���Clearʱ����������̵߳���ҵ��Ͷ�ĵ����߳���Ϣ���е���δִ��ʱ
  ���������������(playwo����)

  2014.8.7
  ==========
  * ������TQJobGroup������ҵʱ�������޸���ҵ���״̬������

  2014.8.2
  ==========
  * ��������Windows��DLL��ʹ��QWorkerʱ�������˳�ʱ���߳��쳣��ֹʱ�������޷���
  ��������(С��ɵ����棬�������֤)
  2014.7.29
  ==========
  + ������������ȫ�ֺ���������ʽ����XE5���ϰ汾�У�����֧������������Ϊ��ҵ����
  [ע��]����������Ӧ���ʾֲ�������ֵ
  2014.7.28
  ==========
  * ������ComNeeded�����������ó�ʼ����ɱ�־λ������(����ұ���)
  2014.7.21
  ==========
  * ������Delphi 2007�޷����������

  2014.7.17
  =========
  * ��������FMXƽ̨�ϱ���ʱ����Hint�Ĵ���
  2014.7.14
  =========
  * ������TQJobGroupû�д���AfterDone�¼�������
  * �޸�������Hint�Ĵ���
  2014.7.12
  =========
  + ����TQJobGroup֧����ҵ����
  2014.7.4
  ========
  * ��������FMX�ļ���������(�ֺ뱨��)
  + ����Clear�����ȫ����ҵ������ʵ��(D10����ҽ���)
  * ֧������ҵ������ͨ������IsTerminated��������ȫ������ʱ���ź���ҵ
  2014.7.3
  =========
  + MakeJobProc��֧��ȫ����ҵ��������
  + TQWorkers.Clear�����������������غ�����ʵ������ָ���źŹ�����ȫ����ҵ(�嶾�����顣����)
  * �������ظ���ҵ����ִ��ʱ�޷�����ɾ�������
  2014.6.26
  =========
  * TEvent.WaitFor����������Խ����Delphi2007�ļ�����(D10-����ұ���)
  * ����HPPEMITĬ�����ӱ���Ԫ(�����ٷ� ����)
  2014.6.23
  =========
  * �޸���Windows�����߳�����ҵ�Ĵ�����ʽ���Ը�����COM�ļ����ԣ�D10-����ұ��棩
  2014.6.21
  =========
  * �����˶�COM��֧�֣������Ҫ����ҵ��ʹ��COM���󣬵���Job.Worker.ComNeeded�󼴿�
  �������ʸ���COM����
  2014.6.19
  =========
  * ������DoMainThreadWork�����Ĳ�������˳�����
  * ΪTQWorker������ComNeeded��������֧��COM�ĳ�ʼ����������ҵ��COM��غ�������
  2014.6.17
  =========
  * �źŴ�����ҵʱ�����븽�����ݳ�Ա���������������ӵ�TQJob�ṹ��Data��Ա���Ա�
  �ϲ�Ӧ���ܹ�����Ҫ�ı�ǣ�Ĭ��ֵΪ��
  * ��ҵͶ��ʱ�����˸��ӵĲ�������������ͷŸ��ӵ����ݶ���
}
{$ENDREGION}

uses
  classes, types, sysutils, SyncObjs, Variants, dateutils, typinfo
{$IFDEF UNICODE}, Generics.Collections{$ENDIF}{$IF RTLVersion>=21},
  Rtti{$IFEND >=XE10}
{$IFNDEF CONSOLE}, Forms{$ENDIF}
{$IFNDEF MSWINDOWS}
, System.Diagnostics
{$ELSE}
{$IFDEF MSWINDOWS}, Windows, Messages, TlHelp32, Activex{$ENDIF}
{$ENDIF}
{$IFDEF POSIX}, Posix.Base, Posix.Unistd, Posix.Signal, Posix.Pthread,
  Posix.Sched, Posix.ErrNo, Posix.SysTypes{$ENDIF}
    , qstring, qrbtree, qtimetypes {$IFDEF ANDROID}, Androidapi.AppGlue,
  Androidapi.Looper, Androidapi.NativeActivity, fmx.Helpers.Android{$ENDIF};
{$HPPEMIT '#pragma link "qworker"'}

{ *QWorker��һ����̨�����߹����������ڹ����̵߳ĵ��ȼ����С���QWorker�У���С��
  ������λ����Ϊ��ҵ��Job������ҵ���ԣ�
  1����ָ����ʱ����Զ����ƻ�ִ�У������ڼƻ�����ֻ��ʱ�ӵķֱ��ʿ��Ը���
  2���ڵõ���Ӧ���ź�ʱ���Զ�ִ����Ӧ�ļƻ�����
  �����ơ�
  1.ʱ��������ʹ��0.1msΪ������λ����ˣ�64λ�������ֵΪ9223372036224000000��
  ����864000000��Ϳɵý��ԼΪ10675199116�죬��ˣ�QWorker�е���ҵ�ӳٺͶ�ʱ�ظ�
  ������Ϊ10675199116�졣
  2�����ٹ�������Ϊ1�����������ڵ����Ļ��Ƕ���Ļ����ϣ�����������ơ������
  ���õ����ٹ�������������ڵ���1������������û��ʵ�����ơ�
  3����ʱ����ҵ�������ó�����๤����������һ�룬����Ӱ��������ͨ��ҵ����Ӧ�����
  Ͷ�ĳ�ʱ����ҵʱ��Ӧ���Ͷ�Ľ����ȷ���Ƿ�Ͷ�ĳɹ�
  * }
const
  JOB_RUN_ONCE = $000001; // ��ҵֻ����һ��
  JOB_IN_MAINTHREAD = $000002; // ��ҵֻ�������߳�������
  JOB_MAX_WORKERS = $000004; // �����ܶ�Ŀ������ܵĹ������߳���������ҵ���ݲ�֧��
  JOB_LONGTIME = $000008; // ��ҵ��Ҫ�ܳ���ʱ�������ɣ��Ա���ȳ����������������ҵ��Ӱ��
  JOB_SIGNAL_WAKEUP = $000010; // ��ҵ�����ź���Ҫ����
  JOB_TERMINATED = $000020; // ��ҵ����Ҫ�������У����Խ�����
  JOB_GROUPED = $000040; // ��ǰ��ҵ����ҵ���һԱ
  JOB_ANONPROC = $000080; // ��ǰ��ҵ��������������
  JOB_FREE_OBJECT = $000100; // Data��������Object����ҵ��ɻ�����ʱ�ͷ�
  JOB_FREE_RECORD = $000200; // Data��������Record����ҵ��ɻ�����ʱ�ͷ�
  JOB_FREE_INTERFACE = $000300; // Data��������Interface����ҵ���ʱ����_Release
  JOB_FREE_CUSTOM1 = $000400; // Data�����ĳ�Ա���û�ָ���ķ�ʽ1�ͷ�
  JOB_FREE_CUSTOM2 = $000500; // Data�����ĳ�Ա���û�ָ���ķ�ʽ2�ͷ�
  JOB_FREE_CUSTOM3 = $000600; // Data�����ĳ�Ա���û�ָ���ķ�ʽ3�ͷ�
  JOB_FREE_CUSTOM4 = $000700; // Data�����ĳ�Ա���û�ָ���ķ�ʽ4�ͷ�
  JOB_FREE_CUSTOM5 = $000800; // Data�����ĳ�Ա���û�ָ���ķ�ʽ5�ͷ�
  JOB_FREE_CUSTOM6 = $000900; // Data�����ĳ�Ա���û�ָ���ķ�ʽ6�ͷ�
  JOB_FREE_PARAMS = $0000A00; // Data�����ĳ�Ա��IQJobNamedParams ���͵Ľӿ�,�ڲ�ʹ��
  JOB_DATA_OWNER = $000F00; // ��ҵ��Data��Ա��������
  JOB_BY_PLAN = $001000; // ��ҵ��Interval��һ��TQPlanMask������ֵ
  JOB_DELAY_REPEAT = $002000; // ��ҵ�Ƕ�������ӳ���ҵ������һ����ɺ󣬲Ż�����´μ��ʱ��
  JOB_AS_FIRST = $004000; // ��ҵ���뵽�б���ǰ�棬���Լ���ҵ��Ч

  JOB_HANDLE_SIMPLE_MASK = $00;
  JOB_HANDLE_REPEAT_MASK = $01;
  JOB_HANDLE_SIGNAL_MASK = $02;
  JOB_HANDLE_PLAN_MASK = $03;

  // ��ҵ���ӳ���ҵ�����´�ִ��ʱ�䲻��������ȡ���� 64 λ����
  JOB_TIME_DELAY = Int64($7FFFFFFFFFFFFFFF);

  WORKER_ISBUSY = $0001; // ������æµ
  WORKER_PROCESSLONG = $0002; // ��ǰ������һ����ʱ����ҵ
  WORKER_COM_INITED = $0004; // �������ѳ�ʼ��Ϊ֧��COM��״̬(����Windows)
  WORKER_LOOKUP = $0008; // ���������ڲ�����ҵ
  WORKER_EXECUTING = $0010; // ����������ִ����ҵ
  WORKER_EXECUTED = $0020; // �������Ѿ������ҵ
  WORKER_FIRING = $0040; // ���������ڱ����
  WORKER_RUNNING = $0080; // �������߳��Ѿ���ʼ����
  WORKER_CLEANING = $0100; // �������߳�����������ҵ
  DEFAULT_FIRE_TIMEOUT = 15000;
  INVALID_JOB_DATA = Pointer(-1);
  Q1MillSecond = 10; // 1ms
  Q1Second = 10000; // 1s
  Q1Minute = 600000; // 60s/1min
  Q1Hour = 36000000; // 3600s/60min/1hour
  Q1Day = Int64(864000000); // 1day
{$IFNDEF UNICODE}
  wrIOCompletion = TWaitResult(4);
{$ENDIF}

type
  TQJobs = class;
  TQWorker = class;
  TQWorkers = class;
  TQJobGroup = class;
  TQForJobs = class;
  PQSignal = ^TQSignal;
  PQJob = ^TQJob;
  /// <summary>��ҵ�����ص�����</summary>
  /// <param name="AJob">Ҫ��������ҵ��Ϣ</param>
  TQJobProc = procedure(AJob: PQJob) of object;
  PQJobProc = ^TQJobProc;
  TQJobProcG = procedure(AJob: PQJob);
  TQForJobProc = procedure(ALoopMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt)
    of object;
  PQForJobProc = ^TQForJobProc;
  TQForJobProcG = procedure(ALoopMgr: TQForJobs; AJob: PQJob;
    AIndex: NativeInt);
{$IFDEF UNICODE}
  TQJobProcA = reference to procedure(AJob: PQJob);
  TQForJobProcA = reference to procedure(ALoopMgr: TQForJobs; AJob: PQJob;
    AIndex: NativeInt);
{$ENDIF}
  /// <summary>��ҵ����ԭ���ڲ�ʹ��</summary>
  /// <remarks>
  /// irNoJob : û����Ҫ��������ҵ����ʱ�����߻�����ͷŵȴ�״̬������ڵȴ�ʱ����
  /// ������ҵ�����������߻ᱻ���ѣ�����ʱ��ᱻ�ͷ�
  /// irTimeout : �������Ѿ��ȴ���ʱ�����Ա��ͷ�
  TWorkerIdleReason = (irNoJob, irTimeout);

  /// <summary>��ҵ����ʱ��δ���Data��Ա</summary>
  /// <remarks>
  /// jdoFreeByUser : �û�����������ͷ�
  /// jdoFreeAsObject : ���ӵ���һ��TObject�̳еĶ�����ҵ���ʱ�����FreeObject�ͷ�
  /// jdfFreeAsSimpleRecord : ���ӵ���һ����¼���ṹ�壩����ҵ���ʱ�����Dispose�ͷ�
  /// ע�������ͷ�ʱʵ������FreeMem���˽ṹ�岻Ӧ�����������ͣ���String/��̬����/Variant����Ҫ
  /// jdtFreeAsInterface : ���ӵ���һ���ӿڶ�������ʱ�����Ӽ�������ҵ���ʱ����ټ���
  /// jdfFreeAsC1 : �û�����ָ�����ͷŷ���1
  /// jdfFreeAsC2 : �û�����ָ�����ͷŷ���2
  /// jdfFreeAsC3 : �û�����ָ�����ͷŷ���3
  /// jdfFreeAsC4 : �û�����ָ�����ͷŷ���4
  /// jdfFreeAsC5 : �Ի�����ָ�����ͷŷ���5
  /// jdfFreeAsC6 : �û�����ָ�����ͷŷ���6
  /// jdfFreeAsParams : IQJobNamedParams ���͵Ĳ���
  /// </remarks>
  TQJobDataFreeType = (jdfFreeByUser, jdfFreeAsObject, jdfFreeAsSimpleRecord,
    jdfFreeAsInterface, jdfFreeAsC1, jdfFreeAsC2, jdfFreeAsC3, jdfFreeAsC4,
    jdfFreeAsC5, jdfFreeAsC6, jdfFreeAsParams);

  TQRunonceTask = record
    CanRun: Integer;
{$IFDEF UNICODE}
    procedure Runonce(ACallback: TProc); overload;
{$ENDIF}
    procedure Runonce(ACallback: TProcedure); overload;
    procedure Runonce(ACallback: TThreadMethod); overload;
  end;

  TQJobPlanData = record
    OriginData: Pointer;
    Runnings: Integer;
    Plan: TQPlanMask;
    DataFreeType: TQJobDataFreeType;
  end;

  PQJobPlanData = ^TQJobPlanData;

  TQExtFreeEvent = procedure(AData: Pointer) of object;
  TQExtInitEvent = procedure(var AData: Pointer) of Object;
{$IFDEF UNICODE}
  TQExtInitEventA = reference to procedure(var AData: Pointer);
  TQExtFreeEventA = reference to procedure(AData: Pointer);
{$ENDIF}

  TQJobParamPair = record
    Name: String;
    Value: Variant;
  end;

  PQJobParamPair = ^TQJobParamPair;

  IQJobNamedParams = interface
    ['{8779E264-0DFC-4944-B989-B9532891A5AF}']
    function GetParam(const AIndex: Integer): PQJobParamPair;
    function GetCount: Integer;
    function ValueByName(const AName: String): Variant;
    property Count: Integer read GetCount;
    property Params[const AIndex: Integer]: PQJobParamPair read GetParam;
  end;

  TQJobExtData = class
  private
    function GetAsBoolean: Boolean;
    function GetAsDouble: Double;
    function GetAsInteger: Integer;
    function GetAsString: QStringW;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsDouble(const Value: Double);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: QStringW);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function GetAsInt64: Int64;
    procedure SetAsInt64(const Value: Int64);
    function GetAsPlan: PQJobPlanData;
    function GetParamCount: Integer;
    function GetParams(AIndex: Integer): Variant;
  protected
    FOrigin: Pointer;
    FOnFree: TQExtFreeEvent;
{$IFDEF UNICODE}
    FOnFreeA: TQExtFreeEventA;
{$ENDIF}
    procedure DoFreeAsString(AData: Pointer);
    procedure DoSimpleTypeFree(AData: Pointer);
    procedure DoFreeAsPlan(AData: Pointer);
    procedure DoFreeAsVariant(AData: Pointer);
{$IFNDEF NEXTGEN}
    function GetAsAnsiString: AnsiString;
    procedure SetAsAnsiString(const Value: AnsiString);
    procedure DoFreeAsAnsiString(AData: Pointer);
{$ENDIF}
  public
    constructor Create(AData: Pointer; AOnFree: TQExtFreeEvent); overload;
    constructor Create(AOnInit: TQExtInitEvent;
      AOnFree: TQExtFreeEvent); overload;
    constructor Create(const APlan: TQPlanMask; AData: Pointer;
      AFreeType: TQJobDataFreeType); overload;
    constructor Create(const AParams: array of const); overload;
{$IFDEF UNICODE}
    constructor Create(AData: Pointer; AOnFree: TQExtFreeEventA); overload;
    constructor Create(AOnInit: TQExtInitEventA;
      AOnFree: TQExtFreeEventA); overload;
{$ENDIF}
    constructor Create(const Value: Int64); overload;
    constructor Create(const Value: Integer); overload;
    constructor Create(const Value: Boolean); overload;
    constructor Create(const Value: Double); overload;
    constructor CreateAsDateTime(const Value: TDateTime); overload;
    constructor Create(const S: QStringW); overload;
{$IFNDEF NEXTGEN}
    constructor Create(const S: AnsiString); overload;
{$ENDIF}
    destructor Destroy; override;
    property Origin: Pointer read FOrigin;
    property AsString: QStringW read GetAsString write SetAsString;
{$IFNDEF NEXTGEN}
    property AsAnsiString: AnsiString read GetAsAnsiString
      write SetAsAnsiString;
{$ENDIF}
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property AsFloat: Double read GetAsDouble write SetAsDouble;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsPlan: PQJobPlanData read GetAsPlan;
    property Params[AIndex: Integer]: Variant read GetParams;
    property ParamCount: Integer read GetParamCount;
  end;

  TQJobMethod = record
    case Integer of
      0:
        (Proc: {$IFNDEF NEXTGEN}TQJobProc{$ELSE}Pointer{$ENDIF});
      1:
        (ProcG: TQJobProcG);
      2:
        (ProcA: Pointer);
      3:
        (ForProc: {$IFNDEF NEXTGEN}TQForJobProc{$ELSE}Pointer{$ENDIF});
      4:
        (ForProcG: TQForJobProcG);
      5:
        (ForProcA: Pointer);
      6:
        (Code: Pointer; Data: Pointer);
      7:
        (Method: TMethod);
  end;

  TQJob = record
  private
    function GetAvgTime: Integer; inline;
    function GetElapsedTime: Int64; inline;
    function GetIsTerminated: Boolean; inline;
    function GetFlags(AIndex: Integer): Boolean; inline;
    procedure SetFlags(AIndex: Integer; AValue: Boolean); inline;
    procedure UpdateNextTime;
    procedure SetIsTerminated(const Value: Boolean);
    procedure AfterRun(AUsedTime: Int64);
    function GetFreeType: TQJobDataFreeType; inline;
    function GetIsCustomFree: Boolean; inline;
    function GetIsObjectOwner: Boolean; inline;
    function GetIsRecordOwner: Boolean; inline;
    function GetIsInterfaceOwner: Boolean; inline;
    function GetExtData: TQJobExtData; inline;
    procedure SetFreeType(const Value: TQJobDataFreeType);
    function GetHandle: IntPtr;
    function GetIsPlanRunning: Boolean;
    function GetIsAnonWorkerProc: Boolean;
    function GetParams: IQJobNamedParams;
  public
    constructor Create(AProc: TQJobProc); overload;

    /// <summary>ֵ��������</summary>
    /// <remarks>Worker/Next/Source���Ḵ�Ʋ��ᱻ�ÿգ�Owner���ᱻ����</remarks>
    procedure Assign(const ASource: PQJob);
    /// <summary>�������ݣ��Ա�Ϊ�Ӷ����е�����׼��</summary>
    procedure Reset; inline;

    /// <summary>�������̶߳����ͬ�������������Ƽ�Ͷ���첽��ҵ�����߳��д���</summary>
    procedure Synchronize(AMethod: TThreadMethod); overload;
{$IFDEF UNICODE}inline; {$ENDIF}
{$IFDEF UNICODE}
    procedure Synchronize(AProc: TThreadProcedure); overload; inline;
{$ENDIF}
    /// <summary>ƽ��ÿ������ʱ�䣬��λΪ0.1ms</summary>
    property AvgTime: Integer read GetAvgTime;
    /// <summmary>����������ʱ�䣬��λΪ0.1ms</summary>
    property ElapsedTime: Int64 read GetElapsedTime;
    /// <summary>�Ƿ�ֻ����һ�Σ�Ͷ����ҵʱ�Զ�����</summary>
    property Runonce: Boolean index JOB_RUN_ONCE read GetFlags;
    /// <summary>�Ƿ�Ҫ�������߳�ִ����ҵ��ʵ��Ч���� Windows �� PostMessage ����</summary>
    property InMainThread: Boolean index JOB_IN_MAINTHREAD read GetFlags;
    /// <summary>�Ƿ���һ������ʱ��Ƚϳ�����ҵ����Workers.LongtimeWork����</summary>
    property IsLongtimeJob: Boolean index JOB_LONGTIME read GetFlags;
    /// <summary>�Ƿ���һ���źŴ�������ҵ</summary>
    property IsSignalWakeup: Boolean index JOB_SIGNAL_WAKEUP read GetFlags;
    /// <summary>�Ƿ��Ƿ�����ҵ�ĳ�Ա</summary>
    property IsGrouped: Boolean index JOB_GROUPED read GetFlags;
    /// <summary>�Ƿ�Ҫ�������ǰ��ҵ</summary>
    property IsTerminated: Boolean read GetIsTerminated write SetIsTerminated;
    /// <summary>�ж���ҵ��Dataָ�����һ��������Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsObjectOwner: Boolean read GetIsObjectOwner;
    /// <summary>�ж���ҵ��Dataָ�����һ����¼��Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsRecordOwner: Boolean read GetIsRecordOwner;
    /// <summary>�ж���ҵ��Data�Ƿ������û���ָ���ķ����Զ��ͷ�</summary>
    property IsCustomFree: Boolean read GetIsCustomFree;
    property FreeType: TQJobDataFreeType read GetFreeType write SetFreeType;
    /// <summary>�ж���ҵ�Ƿ�ӵ��Data���ݳ�Ա
    property IsDataOwner: Boolean index JOB_DATA_OWNER read GetFlags;
    /// <summary>�ж���ҵ��Dataָ�����һ���ӿ���Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsInterfaceOwner: Boolean read GetIsInterfaceOwner;
    /// <summary>�ж���ҵ���������Ƿ���һ����������</summary>
    property IsAnonWorkerProc: Boolean read GetIsAnonWorkerProc;
    /// <summary>��ҵ����һ���ƻ����񴥷�</summary>
    property IsByPlan: Boolean index JOB_BY_PLAN read GetFlags write SetFlags;
    /// <summary>��չ����ҵ������������</summary>
    property ExtData: TQJobExtData read GetExtData;
    /// <summary>�ƻ�������ҵ�Ƿ���ִ����</summary>
    property IsPlanRunning: Boolean read GetIsPlanRunning;
    /// <summary>�Ƿ����ӳ��ظ���ҵ</summary>
    property IsDelayRepeat: Boolean index JOB_DELAY_REPEAT read GetFlags
      write SetFlags;
    /// <summary>��ҵ���ʱ����Ϊ���е��׸�Ԫ��</summary>
    property AsFirst: Boolean index JOB_AS_FIRST read GetFlags write SetFlags;
    /// <summary>��ҵ����ľ��</summary>
    property Handle: IntPtr read GetHandle;
    // <summary>IQJobNamedParams �ӿڶ�Ӧ�Ĳ����б�</summary>
    property Params: IQJobNamedParams read GetParams;
  public
    FirstStartTime: Int64; // ��ҵ��һ�ο�ʼʱ��
    StartTime: Int64; // ������ҵ��ʼʱ��,8B
    PushTime: Int64; // ���ʱ��
    PopTime: Int64; // ����ʱ��
    DoneTime: Int64; // ��ҵ����ʱ��
    NextTime: Int64; // ��һ�����е�ʱ��,+8B=16B
    WorkerProc: TQJobMethod; //
    Owner: TQJobs; // ��ҵ�������Ķ���
    Next: PQJob; // ��һ�����
    Worker: TQWorker; // ��ǰ��ҵ������
    Runs: Integer; // �Ѿ����еĴ���+4B
    MinUsedTime: Cardinal; // ��С����ʱ��+4B
    TotalUsedTime: Cardinal; // �����ܼƻ��ѵ�ʱ�䣬TotalUsedTime/Runs���Եó�ƽ��ִ��ʱ��+4B
    MaxUsedTime: Cardinal; // �������ʱ��+4B
    Flags: Integer; // ��ҵ��־λ+4B
    Data: Pointer; // ������������
    case Integer of
      0:
        (SignalData: Pointer; // �źŴ�����������ݣ�TQSignalQueueItem����
        );
      1:
        (Interval: Int64; // ����ʱ��������λΪ0.1ms��ʵ�ʾ����ܲ�ͬ����ϵͳ����+8B
          FirstDelay: Int64; // �״������ӳ٣���λΪ0.1ms��Ĭ��Ϊ0
          Source: PQJob;
        );
      2: // ������ҵ֧��
        (Group: Pointer;
        );
      3:
        (PlanJob: Pointer;
        );
  end;

  /// <summary>��ҵ״̬����PeekJobState��������</summary>
  TQJobState = record
    Handle: IntPtr; // ��ҵ������
    Proc: TQJobMethod; // ��ҵ����
    Flags: Integer; // ��־λ
    IsRunning: Boolean; // �Ƿ��������У����ΪFalse������ҵ���ڶ�����
    Runs: Integer; // �Ѿ����еĴ���
    EscapedTime: Int64; // �Ѿ�ִ��ʱ��
    PushTime: Int64; // ���ʱ��
    PopTime: Int64; // ����ʱ��
    AvgTime: Int64; // ƽ��ʱ��
    TotalTime: Int64; // ��ִ��ʱ��
    MaxTime: Int64; // ���ִ��ʱ��
    MinTime: Int64; // ��Сִ��ʱ��
    NextTime: Int64; // �ظ���ҵ���´�ִ��ʱ��
    Plan: TQPlanMask; // �ƻ���������
  end;

  TQJobStateArray = array of TQJobState;

  PQJobWaitChain = ^TQJobWaitChain;

  TQJobWaitChain = record
    Job: IntPtr;
    Event: Pointer;
    Prior: PQJobWaitChain;
  end;

  /// <summary>�����߼�¼�ĸ�������</summary>
  // TQJobHelper = record helper for TQJob
  //
  // end;

  // ��ҵ���ж���Ļ��࣬�ṩ�����Ľӿڷ�װ
  TQJobs = class
  protected
    FOwner: TQWorkers;
    function InternalPush(AJob: PQJob): Boolean; virtual; abstract;
    function InternalPop: PQJob; virtual; abstract;
    function GetCount: Integer; virtual; abstract;
    function GetEmpty: Boolean;
    /// <summary>Ͷ��һ����ҵ</summary>
    /// <param name="AJob">ҪͶ�ĵ���ҵ</param>
    /// <remarks>�ⲿ��Ӧ����ֱ��Ͷ�����񵽶��У�����TQWorkers����Ӧ�����ڲ����á�</remarks>
    function Push(AJob: PQJob): Boolean; virtual;
    /// <summary>����һ����ҵ</summary>
    /// <returns>���ص�ǰ����ִ�еĵ�һ����ҵ</returns>
    function Pop: PQJob; virtual;
    /// <summary>���������ҵ</summary>
    procedure Clear; overload; virtual;
    /// <summary>���ָ������ҵ</summary>
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; virtual; abstract;
    /// <summary>���һ�����������������ҵ</summary>
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer; overload;
      virtual; abstract;
    /// <summary>���ݾ�����һ����ҵ����</summary>
    function Clear(AHandle: IntPtr): Boolean; overload; virtual;
    /// <summary>���ݾ���б����һ����ҵ����</summary>
    function ClearJobs(AHandes: PIntPtr; ACount: Integer): Integer; overload;
      virtual; abstract;
  public
    constructor Create(AOwner: TQWorkers); overload; virtual;
    destructor Destroy; override;
    /// ���ɿ����棺Count��Emptyֵ����һ���ο����ڶ��̻߳����¿��ܲ�����֤��һ�����ִ��ʱ����һ��
    property Empty: Boolean read GetEmpty; // ��ǰ�����Ƿ�Ϊ��
    property Count: Integer read GetCount; // ��ǰ����Ԫ������
  end;

  TQSimpleLock = TCriticalSection;

  // TQSimpleJobs���ڹ����򵥵��첽���ã�û�д���ʱ��Ҫ�����ҵ
  TQSimpleJobs = class(TQJobs)
  protected
    FFirst, FLast: PQJob;
    FCount: Integer;
    FLocker: TQSimpleLock;
    function InternalPush(AJob: PQJob): Boolean; override;
    function InternalPop: PQJob; override;
    function GetCount: Integer; override;
    procedure Clear; overload; override;
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
      overload; override;
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; override;
    function Clear(AHandle: IntPtr): Boolean; overload; override;
    function ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
      overload; override;
    function PopAll: PQJob; inline;
    procedure Repush(ANewFirst: PQJob);
  public
    constructor Create(AOwner: TQWorkers); override;
    destructor Destroy; override;
  end;

  // TQRepeatJobs���ڹ����ƻ���������Ҫ��ָ����ʱ��㴥��
  TQRepeatJobs = class(TQJobs)
  protected
    FItems: TQRBTree;
    FLocker: TCriticalSection;
    FFirstFireTime: Int64;
    function InternalPush(AJob: PQJob): Boolean; override;
    function InternalPop: PQJob; override;
    function DoTimeCompare(P1, P2: Pointer): Integer;
    procedure DoJobDelete(ATree: TQRBTree; ANode: TQRBNode);
    function GetCount: Integer; override;
    procedure Clear; override;
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
      overload; override;
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; override;
    function Clear(AHandle: IntPtr): Boolean; overload; override;
    function ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
      overload; override;
    procedure AfterJobRun(AJob: PQJob; AUsedTime: Int64);
  public
    constructor Create(AOwner: TQWorkers); override;
    destructor Destroy; override;
  end;

  PQSignalQueueItem = ^TQSignalQueueItem;

  TQSignalQueueItem = record
    Id: Integer; // Ҫ�������ź�ID
    Data: Pointer; // �����ź�ʱ���ݵ� Data ��ֵ
    RefCount: Integer; // ���ü���
    FireCount: Integer; // �����е���ҵ��
    FreeType: TQJobDataFreeType; // �����ź�ʱ���ݵ��ͷŷ�ʽ
    WaitEvent: Pointer; // �ȴ�������ɵ��¼�
    Next: PQSignalQueueItem; // ��һ��Ҫ�������ź�
  end;

  TQSignalQueue = class
  protected
    FFirst, FLast: PQSignalQueueItem; // �����е���ĩԪ��
    FCount: Integer; // �����е�Ԫ�ظ���
    FMaxItems: Integer; // ����������������Ŷӵ��ź�����
    FLocker: TQSimpleLock; // ͬ����
    FOwner: TQWorkers; // ����������
    FLastPop: Pointer; // ��󵯳����ź�
    procedure Clear;
    function InternalPost(AItem: PQSignalQueueItem): Boolean;
    function NewItem(AId: Integer; AData: Pointer; AFreeType: TQJobDataFreeType;
      AWaiter: TEvent): PQSignalQueueItem;
    procedure FreeItem(AItem: PQSignalQueueItem);
    procedure FireNext;
    procedure SingalJobDone(AItem: PQSignalQueueItem);
  public
    constructor Create(AOwner: TQWorkers); overload;
    destructor Destroy; override;

    /// <summary>
    /// Ͷ��һ���źŵ�������
    /// </summary>
    /// <param name="AId">
    /// �ź� ID
    /// </param>
    /// <param name="AData">
    /// ��������
    /// </param>
    /// <param name="AFreeType">
    /// ���������ͷŷ�ʽ
    /// </param>
    /// <returns>
    /// �����ҵ�ɹ���Ͷ�ݵ������У��򷵻� true�����򷵻� false��
    /// </returns>
    /// <remarks>
    /// Post �������е��źŻ�ȴ�ǰһ���źŴ�����ɣ��Żᴥ����һ�������Բ��ʺ���Ҫ����������Ӧ�Ĳ�����
    /// </remarks>
    function Post(AId: Integer; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>
    /// Ͷ��һ���źŵ�������
    /// </summary>
    /// <param name="AName">
    /// �ź�����
    /// </param>
    /// <param name="AData">
    /// ��������
    /// </param>
    /// <param name="AFreeType">
    /// ���������ͷŷ�ʽ
    /// </param>
    /// <returns>
    /// �����ҵ�ɹ���Ͷ�ݵ������У��򷵻� true�����򷵻� false��
    /// </returns>
    /// <remarks>
    /// Post �������е��źŻ�ȴ�ǰһ���źŴ�����ɣ��Żᴥ����һ�������Բ��ʺ���Ҫ����������Ӧ�Ĳ�����
    /// </remarks>
    function Post(AName: QStringW; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>
    /// ��������һ���ź�ִ��
    /// </summary>
    /// <param name="AId">
    /// �ź� ID
    /// </param>
    /// <param name="AData">
    /// ��������
    /// </param>
    /// <param name="AFreeType">
    /// ���������ͷŷ�ʽ
    /// </param>
    /// <param name="ATimeout">
    /// �ȴ��źŴ�����ɵĳ�ʱ�����Ϊ0���򲻵ȴ������źŴ�����ɺ���������
    /// </param>
    /// <returns>
    /// ���
    /// ATimeout&gt;0���������ָ���ĳ�ʱ����ɣ��Ǿͻ᷵��wrSignaled�����δִ���꣬�᷵��wrTimeout��������������
    /// wrSignaled <br />
    /// </returns>
    /// <remarks>
    /// Send �����������źŲ����������ִ���ɷ��������߶����а���ִ�У�ʵ�ʵ�ִ��ʱ���ܵ�ǰ�Ŀ��ù������������ƣ��п��ܲ�������ִ��
    /// </remarks>

    function Send(AId: Integer; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser;
      ATimeout: Cardinal = INFINITE): TWaitResult; overload;
    /// <summary>
    /// ��������һ���ź�ִ��
    /// </summary>
    /// <param name="AName">
    /// �ź�����
    /// </param>
    /// <param name="AData">
    /// ��������
    /// </param>
    /// <param name="AFreeType">
    /// ���������ͷŷ�ʽ
    /// </param>
    /// <param name="ATimeout">
    /// �ȴ��źŴ�����ɵĳ�ʱ�����Ϊ0���򲻵ȴ������źŴ�����ɺ���������
    /// </param>
    /// <returns>
    /// ���
    /// ATimeout&gt;0���������ָ���ĳ�ʱ����ɣ��Ǿͻ᷵��wrSignaled�����δִ���꣬�᷵��wrTimeout��������������
    /// wrSignaled <br />
    /// </returns>
    /// <remarks>
    /// Send �����������źŲ����������ִ���ɷ��������߶����а���ִ�У�ʵ�ʵ�ִ��ʱ���ܵ�ǰ�Ŀ��ù������������ƣ��п��ܲ�������ִ��
    /// </remarks>
    function Send(AName: QStringW; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser;
      ATimeout: Cardinal = INFINITE): TWaitResult; overload;

    /// <summary>
    /// ��������������ź����������Ĭ��Ϊ4096
    /// </summary>
    /// <remarks>
    /// ע�⣬���ڶ����е���Ŀ�����δ��������Եȴ��źŵĺ����Ƿ�ִ�в�ȡ�����ź�Ͷ��ʱ�ĵȴ���������������ȡ�����źŴ���ʱ�ĵȴ���������
    /// </remarks>
    property MaxItems: Integer read FMaxItems write FMaxItems;
    /// <summary>
    /// ��ǰ������ʵ�ʵ�Ԫ�ظ���
    /// </summary>
    property Count: Integer read FCount;
  end;

  TQJobStatics = record
    // <summary>����ҵ���� ���ȼ��� Pending+Running ��ֵ </summary>
    Total: Integer;
    // <summary>�ȴ��е���ҵ���� ����������ҵ+ �ظ���ҵ+�ƻ�����+�źŵȴ���ҵ��������ע��ƻ�����ʵ��ִ��ʱ��Ͷ�ݼ���ҵ�����ִ�У����Ա���Ŀͳ�Ƶ�ֵ�п��ܴ��� EnumJobs ���ص��������� </summary>
    Pending: Integer;
    // <summary>�����е���ҵ����</summary>
    Running: Integer;
  end;

  //
  TQWorkerExtClass = class of TQWorkerExt;

  TQWorkerExt = class
  protected
    FOwner: TQWorker;
  public
    constructor Create(AOwner: TQWorker); overload; virtual;
    property Owner: TQWorker read FOwner;
  end;

  { �������߳�ʹ����������������ǽ��������������Ϊ���ڹ������������ޣ�����
    �Ĵ�����������ֱ����򵥵�ѭ��ֱ����Ч
  }
  TQWorker = class(TThread)
  private
    class var FMainThreadJob: PQJob;
  protected
    FOwner: TQWorkers;
    FEvent: TEvent;
    FTimeout: Cardinal;
    FFireDelay: Cardinal;
    FFlags: Integer;
    FProcessed: Cardinal;
    FActiveJobFlags: Integer;
    FActiveJob: PQJob;
    // ֮���Բ�ֱ��ʹ��FActiveJob����ط���������Ϊ��֤�ⲿ�����̰߳�ȫ�ķ�����������Ա
    FActiveJobProc: TQJobMethod;
    FActiveJobData: Pointer;
    FActiveJobSource: PQJob;
    FActiveJobGroup: TQJobGroup;
    FTerminatingJob: PQJob;
    FLastActiveTime: Int64;
    FPending: Boolean; // �Ѿ��ƻ���ҵ
    FTag: IntPtr;
    FExtObject: TQWorkerExt;
{$IFDEF MSWINDOWS}
    FThreadName: String;
{$ENDIF}
    FSyncEvent: TEvent;
    procedure Execute; override;
    procedure AfterExecute;
    procedure FireInMainThread;
    procedure DoJob(AJob: PQJob);
    function GetExtObject: TQWorkerExt;
    function GetIsIdle: Boolean; inline;
    procedure SetFlags(AIndex: Integer; AValue: Boolean); inline;
    function GetFlags(AIndex: Integer): Boolean; inline;
    function WaitSignal(ATimeout: Cardinal; AByRepeatJob: Boolean)
      : TWaitResult; inline;
  public
    constructor Create(AOwner: TQWorkers); overload;
    destructor Destroy; override;
    procedure ComNeeded(AInitFlags: Cardinal = 0);
    procedure ForceQuit;
    /// <summary>�жϵ�ǰ�Ƿ��ڳ�ʱ����ҵ����������</summary>
    property InLongtimeJob: Boolean index WORKER_PROCESSLONG read GetFlags;
    /// <summary>�жϵ�ǰ�Ƿ����</summary>
    property IsIdle: Boolean read GetIsIdle;
    /// <summary>�жϵ�ǰ�Ƿ�æµ</summary>
    property IsBusy: Boolean index WORKER_ISBUSY read GetFlags;
    property IsLookuping: Boolean index WORKER_LOOKUP read GetFlags;
    property IsExecuting: Boolean index WORKER_EXECUTING read GetFlags;
    property IsExecuted: Boolean index WORKER_EXECUTED read GetFlags;
    property IsFiring: Boolean index WORKER_FIRING read GetFlags;
    property IsRunning: Boolean index WORKER_RUNNING read GetFlags;
    property IsCleaning: Boolean index WORKER_CLEANING read GetFlags;
    /// <summary>�ж�COM�Ƿ��Ѿ���ʼ��Ϊ֧��COM
    property ComInitialized: Boolean index WORKER_COM_INITED read GetFlags;
    property ExtObject: TQWorkerExt read GetExtObject;
    property Tag: IntPtr read FTag write FTag;
  end;

  /// <summary>�źŵ��ڲ�����</summary>
  TQSignal = record
    Id: Integer;
    /// <summary>�źŵı���</summary>
    Fired: Integer; // <summary>�ź��Ѵ�������</summary>
    Name: QStringW;
    /// <summary>�źŵ�����</summary>
    First: PQJob;
    /// <summary>�׸���ҵ</summary>
  end;

  TWorkerWaitParam = record
    WaitType: Byte;
    Data: Pointer;
    case Integer of
      0:
        (Bound: Pointer); // ���������
      1:
        (WorkerProc: TMethod;);
      2:
        (SourceJob: PQJob);
      3:
        (Group: Pointer);
  end;
  /// <summary>������Դ����ȡֵ������
  /// jesExecute : ִ��ʱ����
  /// jesFreeData : �ͷŸ�������ʱ����
  /// jesWaitDone : �ڵȴ���ҵ���ʱ����
  /// jesCleanup : ������ҵ���ʱ����
  /// </summary>

  TJobErrorSource = (jesExecute, jesFreeData, jesWaitDone, jesCleanup);
  // For����������ֵ����
  TForLoopIndexType = {$IF RTLVersion>=26}NativeInt{$ELSE}Integer{$IFEND};
  /// <summary>�����ߴ���֪ͨ�¼�</summary>
  /// <param name="AJob">�����������ҵ����</param>
  /// <param name="E">���������쳣����</param>
  /// <param name="ErrSource">������Դ</param>
  TWorkerErrorNotify = procedure(AJob: PQJob; E: Exception;
    const ErrSource: TJobErrorSource) of object;
  // �Զ��������ͷ��¼�
  TQCustomFreeDataEvent = procedure(ASender: TQWorkers;
    AFreeType: TQJobDataFreeType; const AData: Pointer);
  TQJobNotifyEvent = procedure(AJob: PQJob);

  TQWorkerStatusItem = record
    LastActive: Int64;
    Processed: Cardinal;
    ThreadId: TThreadId;
    IsIdle: Boolean;
    ActiveJob: QStringW;
    Stacks: QStringW;
    Timeout: Cardinal;
  end;

  TQWorkerStatus = array of TQWorkerStatusItem;

  /// <summary>�����߹��������������������ߺ���ҵ</summary>
  TQWorkers = class
  private

  protected
    FWorkers: array of TQWorker; // ����������
    FDisableCount: Integer;
    // DisableWorkers �ĵ��ô����������� EnableWorkers ��ƥ�䣬������ҵ���޷�ִ��
    FMinWorkers: Integer; // ��С����������
    FMaxWorkers: Integer; // �����������
    FWorkerCount: Integer; // ��ǰ����������
    FBusyCount: Integer; // ��ǰ���������
    FFiringWorkerCount: Integer; // ��ǰ���ڽ���еĹ���������
    FSignalJobCount: Integer; // ��ǰע�����Ϣ����ҵ����
    FFireTimeout: Cardinal; // �����߽�͵Ļ�׼��ʱ����Сʱ�䣩����λ����
    FJobFrozenTime: Cardinal; // ��ҵ���������Ļ�׼��ʱ����λΪ��
    FMainThreadJobs: {$IF RTLVersion>=24}Cardinal{$ELSE}Integer{$IFEND};
    FLongTimeWorkers: Integer; // ��¼�³�ʱ����ҵ�еĹ����ߣ���������ʱ�䲻�ͷ���Դ�����ܻ�������������޷���ʱ��Ӧ
    FMaxLongtimeWorkers: Integer; // �������ͬʱִ�еĳ�ʱ��������������������MaxWorkers��һ��
    FLocker: TCriticalSection; // ��
    FSimpleJobs: TQSimpleJobs; // ����ҵ�б�
    FPlanJobs: TQSimpleJobs; // �ƻ����񣬻�ÿ���Ӽ��һ�������Ƿ�����Ҫִ�е���ҵ
    FRepeatJobs: TQRepeatJobs; // �ظ���ҵ�б�
    FSignalJobs: array of PQSignal; // �ź���ҵ���飬ÿ���ź�ά����������ҵ�б�
    FSignalNameList: TList; // �������������ź��б����Ż������Ʒ���Ч��
    FMaxSignalId: Integer; // ��ǰ����źŵ�Id
    FTerminating: Boolean; // �Ƿ����ڽ�����
    FStaticThread: TThread; // ��̨���ͳ���߳�
    FOnError: TWorkerErrorNotify; // ����ʱ�����¼�
    FBeforeExecute: TQJobNotifyEvent; // ��ҵִ��ǰ�����¼�
    FAfterExecute: TQJobNotifyEvent; // ��ҵִ���괥���¼�
    FBeforeCancel: TQJobNotifyEvent; // ��ҵȡ��ǰ�����¼�
    FLastWaitChain: PQJobWaitChain; // ��ҵ�ȴ�����
    FSignalQueue: TQSignalQueue; // �ź���ҵ���ȹ�����
    FOnCustomFreeData: TQCustomFreeDataEvent; // �Զ�����ͷ����ݻص�����
    FOnJobFrozen: TQJobProc;
    FWorkerExtClass: TQWorkerExtClass;
    FTerminateEvent: TEvent; // �˳�ʱ�ȴ������߽����¼�
    function Popup: PQJob;
    procedure SetMaxWorkers(Value: Integer);
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetMinWorkers(const Value: Integer);
    procedure WorkerTimeout(AWorker: TQWorker); inline;
    procedure WorkerTerminate(AWorker: TQWorker);
    procedure FreeJob(AJob: PQJob);
    function LookupIdleWorker(AFromStatic: Boolean): Boolean;
    procedure ClearWorkers;
    procedure SignalWorkDone(AJob: PQJob; AUsedTime: Int64);
    procedure DoJobFree(ATable: TQHashTable; AHash: Cardinal; AData: Pointer);
    function Post(AJob: PQJob): IntPtr; overload;
    procedure SetMaxLongtimeWorkers(const Value: Integer);
    function FindSignal(const AName: QStringW; var AIndex: Integer): Boolean;
    procedure FireSignalJob(AData: PQSignalQueueItem);
    function ClearSignalJobs(ASource: PQJob;
      AWaitRunningDone: Boolean = true): Integer;
    procedure WaitSignalJobsDone(AJob: PQJob);
    procedure WaitRunningDone(const AParam: TWorkerWaitParam;
      AMarkTerminateOnly: Boolean = false);
    procedure FreeJobData(AData: Pointer; AFreeType: TQJobDataFreeType);
    procedure DoCustomFreeData(AFreeType: TQJobDataFreeType;
      const AData: Pointer);
    function GetIdleWorkers: Integer; inline;
    function GetBusyCount: Integer; inline;
    function GetOutWorkers: Boolean; inline;
    procedure SetFireTimeout(const Value: Cardinal);
    procedure ValidWorkers; inline;
    procedure NewWorkerNeeded;
    function CreateWorker(ASuspended: Boolean): TQWorker;
    function GetNextRepeatJobTime: Int64; inline;
    procedure DoPlanCheck;
    procedure AfterPlanRun(AJob: PQJob; AUsedTime: Int64);
    function HandleToJob(const AHandle: IntPtr): PQJob; inline;
    procedure CheckWaitChain(AJob: PQJob);
    function GetTerminating: Boolean;
  public
    constructor Create(AMinWorkers: Integer = 2); overload;
    destructor Destroy; override;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="AInserToFirst">������ҵ���뵽�����ײ����Ա���ҵ����ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProc; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser;
      AInsertToFirst: Boolean = false): IntPtr; overload;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProc; const AParams: array of TQJobParamPair;
      ARunInMainThread: Boolean = false; AInsertToFirst: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="AInserToFirst">������ҵ���뵽�����ײ����Ա���ҵ����ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcG; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser;
      AInsertToFirst: Boolean = false): IntPtr; overload;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AInserToFirst">������ҵ���뵽�����ײ����Ա���ҵ����ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcG; const AParams: array of TQJobParamPair;
      ARunInMainThread: Boolean = false; AInsertToFirst: Boolean = false)
      : IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="AInserToFirst">������ҵ���뵽�����ײ����Ա���ҵ����ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcA; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser;
      AInsertToFirst: Boolean = false): IntPtr; overload;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AInserToFirst">������ҵ���뵽�����ײ����Ա���ҵ����ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcA; const AParams: array of TQJobParamPair;
      ARunInMainThread: Boolean = false; AInsertToFirst: Boolean = false)
      : IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProc; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProc; AInterval: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcG; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcG; AInterval: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcA; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcA; AInterval: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProc; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; ARepeat: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProc; ADelay: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false;
      ARepeat: Boolean = false): IntPtr; overload;

    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProcG; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; ARepeat: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProcG; ADelay: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false;
      ARepeat: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProcA; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; ARepeat: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProcA; ADelay: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false;
      ARepeat: Boolean = false): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ�룬��������Ӧ�����У�ͨ�� AJob.Source.Data ������</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProc; ASignalId: Integer;
      ARunInMainThread: Boolean = false; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Source.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProc; ASignalId: Integer;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalName">�ȴ����ź�����</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ�룬��������Ӧ�����У�ͨ�� AJob.Source.Data ������</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProc; const ASignalName: QStringW;
      ARunInMainThread: Boolean = false; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalName">�ȴ����ź�����</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Source.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProc; const ASignalName: QStringW;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ�룬��������Ӧ�����У�ͨ�� AJob.Source.Data ������</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcG; ASignalId: Integer;
      ARunInMainThread: Boolean = false; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Source.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcG; ASignalId: Integer;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Source.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcG; const ASignalName: QStringW;
      ARunInMainThread: Boolean = false; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalName">�ȴ����ź�����</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Source.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcG; const ASignalName: QStringW;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ�룬��������Ӧ�����У�ͨ�� AJob.Source.Data ������</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcA; ASignalId: Integer;
      ARunInMainThread: Boolean = false; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Source.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcA; ASignalId: Integer;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalName">�ȴ����ź�����</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ�룬��������Ӧ�����У�ͨ�� AJob.Source.Data ������</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcA; const ASignalName: QStringW;
      ARunInMainThread: Boolean = false; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalName">�ȴ����ź�����</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Source.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcA; const ASignalName: QStringW;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProc; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProc; const ADelay, AInterval: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProc; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProc; const ATime: TDateTime;
      const AInterval: Int64; const AParams: array of TQJobParamPair;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcG; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcG; const ATime: TDateTime;
      const AInterval: Int64; const AParams: array of TQJobParamPair;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcA; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcA; const ATime: TDateTime;
      const AInterval: Int64; const AParams: array of TQJobParamPair;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProc; const APlan: TQPlanMask; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProc; const APlan: TQPlanMask;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcG; const APlan: TQPlanMask;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;

    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProc; const APlan: QStringW; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcG; const APlan: TQPlanMask; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcG; const APlan: QStringW; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProc; const APlan: QStringW;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcG; const APlan: QStringW;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;

{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcA; const APlan: TQPlanMask; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcA; const APlan: TQPlanMask;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcA; const APlan: QStringW; AData: Pointer;
      ARunInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcA; const APlan: QStringW;
      const AParams: array of TQJobParamPair; ARunInMainThread: Boolean = false)
      : IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function LongtimeJob(AProc: TQJobProc; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function LongtimeJob(AProc: TQJobProcG; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function LongtimeJob(AProc: TQJobProcA; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$ENDIF}
    /// <summary>���������ҵ</summary>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ��������е���ҵ��ɣ�Ĭ��Ϊ true �ȴ�</param>
    procedure Clear(AWaitRunningDone: Boolean = true); overload;
    /// <summary>���һ��������ص�������ҵ</summary>
    /// <param name="AObject">Ҫ�ͷŵ���ҵ�������̹�������</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <returns>����ʵ���������ҵ����</returns>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ��������е���ҵ��ɣ�Ĭ��Ϊ true �ȴ�</param>
    /// <remarks>һ����������ƻ�����ҵ�������Լ��ͷ�ǰӦ���ñ������������������ҵ��
    /// ����δ��ɵ���ҵ���ܻᴥ���쳣��</remarks>
    function Clear(AObject: Pointer; AMaxTimes: Integer = -1;
      AWaitRunningDone: Boolean = true): Integer; overload;
    /// <summary>�������Ͷ�ĵ�ָ��������ҵ</summary>
    /// <param name="AProc">Ҫ�������ҵִ�й���</param>
    /// <param name="AData">Ҫ�������ҵ��������ָ���ַ�����ֵΪPointer(-1)��
    /// ��������е���ع��̣�����ֻ����������ݵ�ַһ�µĹ���</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ��������е���ҵ��ɣ�Ĭ��Ϊ true �ȴ�</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer = -1;
      AWaitRunningDone: Boolean = true): Integer; overload;
    /// <summary>�������Ͷ�ĵ�ָ��������ҵ</summary>
    /// <param name="AProc">Ҫ�������ҵִ�й���</param>
    /// <param name="AData">Ҫ�������ҵ��������ָ���ַ�����ֵΪPointer(-1)��
    /// ��������е���ع��̣�����ֻ����������ݵ�ַһ�µĹ���</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ��������е���ҵ��ɣ�Ĭ��Ϊ true �ȴ�</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(AProc: TQJobProcG; AData: Pointer; AMaxTimes: Integer = -1;
      AWaitRunningDone: Boolean = true): Integer; overload;
{$IFDEF UNICODE}
    /// <summary>�������Ͷ�ĵ�ָ��������ҵ</summary>
    /// <param name="AProc">Ҫ�������ҵִ�й���</param>
    /// <param name="AData">Ҫ�������ҵ��������ָ���ַ�����ֵΪPointer(-1)��
    /// ��������е���ع��̣�����ֻ����������ݵ�ַһ�µĹ���</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ��������е���ҵ��ɣ�Ĭ��Ϊ true �ȴ�</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(AProc: TQJobProcA; AData: Pointer; AMaxTimes: Integer = -1;
      AWaitRunningDone: Boolean = true): Integer; overload;
{$ENDIF}
    /// <summary>���ָ���źŹ�����������ҵ</summary>
    /// <param name="ASingalName">Ҫ������ź�����</param>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ��������е���ҵ��ɣ�Ĭ��Ϊ true �ȴ�</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(ASignalName: QStringW; AWaitRunningDone: Boolean = true)
      : Integer; overload;
    /// <summary>���ָ���źŹ�����������ҵ</summary>
    /// <param name="ASingalId">Ҫ������ź�ID</param>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ��������е���ҵ��ɣ�Ĭ��Ϊ true �ȴ�</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(ASignalId: Integer; AWaitRunningDone: Boolean = true)
      : Integer; overload;
    /// <summary>���ָ�������Ӧ����ҵ</summary>
    /// <param name="ASingalId">Ҫ�������ҵ���</param>
    /// <param name="AWaitRunningDone">�����ҵ����ִ���У��Ƿ�ȴ����</param>
    /// <returns>����ʵ���������ҵ����</returns>
    procedure ClearSingleJob(AHandle: IntPtr;
      AWaitRunningDone: Boolean = true); overload;

    /// <summary>���ָ���ľ���б��ж�Ӧ����ҵ</summary>
    /// <param name="AHandles">��Post/At��Ͷ�ݺ������صľ���б�</param>
    /// <parma name="ACount">AHandles��Ӧ�ľ������</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function ClearJobs(AHandles: PIntPtr; ACount: Integer;
      AWaitRunningDone: Boolean = true): Integer; overload;
    /// <summary>����һ���ź�</summary>
    /// <param name="AId">�źű��룬��RegisterSignal����</param>
    /// <param name="AData">���Ӹ���ҵ���û�����ָ���ַ</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="AWaitTimeout">�ȴ����й�����ҵִ����ɳ�ʱʱ�䣬��λΪ����</param>
    /// <returns>����ȴ�ʱ�䲻Ϊ0���򷵻صȴ���������Ϊ0���򷵻�wrSignaled</returns>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ����������̵�ִ��</remarks>
    function Signal(AId: Integer; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    /// <summary>����һ���ź�</summary>
    /// <param name="AId">�źű��룬��RegisterSignal����</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="AWaitTimeout">�ȴ����й�����ҵִ����ɳ�ʱʱ�䣬��λΪ����</param>
    /// <returns>����ȴ�ʱ�䲻Ϊ0���򷵻صȴ���������Ϊ0���򷵻�wrSignaled</returns>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ����������̵�ִ��</remarks>
    function Signal(AId: Integer; const AParams: array of TQJobParamPair;
      AWaitTimeout: Cardinal = 0): TWaitResult; overload;
    /// <summary>�����ƴ���һ���ź�</summary>
    /// <param name="AName">�ź�����</param>
    /// <param name="AData">���Ӹ���ҵ���û�����ָ���ַ</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="AWaitTimeout">�ȴ����й�����ҵִ����ɳ�ʱʱ�䣬��λΪ����</param>
    /// <returns>����ȴ�ʱ�䲻Ϊ0���򷵻صȴ���������Ϊ0���򷵻�wrSignaled</returns>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ����������̵�ִ��</remarks>
    function Signal(const AName: QStringW; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    /// <summary>�����ƴ���һ���ź�</summary>
    /// <param name="AName">�ź�����</param>
    /// <param name="AParams">��ҵ���ӵĶ���������ò���ͨ�� AJob.Params ���Է���</param>
    /// <param name="AWaitTimeout">�ȴ����й�����ҵִ����ɳ�ʱʱ�䣬��λΪ����</param>
    /// <returns>����ȴ�ʱ�䲻Ϊ0���򷵻صȴ���������Ϊ0���򷵻�wrSignaled</returns>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ����������̵�ִ��</remarks>
    function Signal(const AName: QStringW;
      const AParams: array of TQJobParamPair; AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload;
    function SendSignal(AId: Integer; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    function SendSignal(const AName: QStringW; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    function PostSignal(AId: Integer; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload; inline;
    function PostSignal(const AName: QStringW; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload; inline;
    /// <summary>ע��һ���ź�</summary>
    /// <param name="AName">�ź�����</param>
    /// <remarks>
    /// 1.�ظ�ע��ͬһ���Ƶ��źŽ�����ͬһ������
    /// 2.�ź�һ��ע�ᣬ��ֻ�г����˳�ʱ�Ż��Զ��ͷ�
    /// </remarks>
    function RegisterSignal(const AName: QStringW): Integer; // ע��һ���ź�����
    /// <summary>��ȡָ����ID��Ӧ���ź�����</summary>
    /// <param name="AId">�ź� ID</param>
    /// <return>����ID��Ӧ���ź����ƣ���������ڣ����ؿ��ַ���</return>
    function NameOfSignal(const AId: Integer): QStringW;
    /// <summary>���ù�����</summary>
    /// <remarks>��DisableWorkers�������ʹ��</remarks>
    procedure EnableWorkers;
    /// <summary>�������й�����</summary>
    /// <remarks>�������й����߽�ʹ�������޷���ȡ���µ���ҵ��ֱ������EnableWorkers</remarks>
    procedure DisableWorkers;
    /// <summary>ö�����й�����״̬</summary>
    function EnumWorkerStatus: TQWorkerStatus;
    /// <summary>��ȡָ����ҵ��״̬</summary>
    /// <param name="AHandle">��ҵ������</param>
    /// <param name="AResult">��ҵ����״̬</param>
    /// <returns>���ָ������ҵ���ڣ��򷵻�True�����򣬷���False</returns>
    /// <remarks>
    /// 1.����ִֻ��һ�ε���ҵ����ִ����󲻸����ڣ�����Ҳ�᷵��false
    /// 2.��FMXƽ̨�����ʹ��������������ҵ���̣�������� ClearJobState ������ִ���������̣��Ա����ڴ�й¶��
    /// </remarks>
    function PeekJobState(AHandle: IntPtr; var AResult: TQJobState): Boolean;
    /// <summary>ͳ�Ƶ�ǰ���к��Ŷ��е���ҵ���� </summary>
    function PeekJobStatics: TQJobStatics;
    /// <summary>ö�����е���ҵ״̬</summary>
    /// <returns>������ҵ״̬�б�</summary>
    /// <remarks>��FMXƽ̨�����ʹ��������������ҵ���̣�������� ClearJobStates ������ִ����������</remarks>
    function EnumJobStates: TQJobStateArray;
    /// <summary>�ȴ�ָ������ҵ����</summary>
    /// <param name="AHandle">Ҫ�ȴ�����ҵ������</param>
    /// <param name="ATimeout">��ʱʱ�䣬��λΪ����</param>
    /// <param name="AMsgWait">�ȴ�ʱ�Ƿ���Ӧ��Ϣ</param>
    /// <returns>�����ҵ������ͨ��ҵ���򷵻�wrError�������ҵ�����ڻ��Ѿ����������� wrSignal�����򣬷��� wrTimeout</returns>
    function WaitJob(AHandle: IntPtr; ATimeout: Cardinal; AMsgWait: Boolean)
      : TWaitResult;
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProc; AMsgWait: Boolean = false;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static; inline;
{$IFDEF UNICODE}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcA; AMsgWait: Boolean = false;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static; inline;
{$ENDIF}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcG; AMsgWait: Boolean = false;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static; inline;
    /// <summary>�����������������������С��2</summary>
    property MaxWorkers: Integer read FMaxWorkers write SetMaxWorkers;
    /// <summary>��С����������������С��2<summary>
    property MinWorkers: Integer read FMinWorkers write SetMinWorkers;
    /// <summary>��������ĳ�ʱ����ҵ�������������ȼ���������ʼ�ĳ�ʱ����ҵ����</summary>
    property MaxLongtimeWorkers: Integer read FMaxLongtimeWorkers
      write SetMaxLongtimeWorkers;
    /// <summary>�Ƿ�������ʼ��ҵ�����Ϊfalse����Ͷ�ĵ���ҵ�����ᱻִ�У�ֱ���ָ�ΪTrue</summary>
    /// <remarks>EnabledΪFalseʱ�Ѿ����е���ҵ����Ȼ���У���ֻӰ����δִ�е�����</remarks>
    property Enabled: Boolean read GetEnabled write SetEnabled;
    /// <summary>�Ƿ������ͷ�TQWorkers��������</summary>
    property Terminating: Boolean read GetTerminating;
    /// <summary>��ǰ����������</summary>
    property Workers: Integer read FWorkerCount;
    /// <summary>��ǰæµ����������</summary>
    property BusyWorkers: Integer read GetBusyCount;
    /// <summary>��ǰ���й���������</summary>
    property IdleWorkers: Integer read GetIdleWorkers;

    /// <summary>�Ƿ��Ѿ����������������</summary>
    property OutOfWorker: Boolean read GetOutWorkers;
    /// <summary>Ĭ�Ͻ�͹����ߵĳ�ʱʱ��</summary>
    property FireTimeout: Cardinal read FFireTimeout write SetFireTimeout;
    /// <summary>Ĭ��һ����ҵ���ִ��ʱ�䣬�������ʱ�䣬���ᴥ�� OnJobFrozen �¼��Ա��û����б�Ҫ�Ĵ���</summary>
    property JobFrozenTime: Cardinal read FJobFrozenTime write FJobFrozenTime;
    /// <summary>�û�ָ������ҵ��Data�����ͷŷ�ʽ</summary>
    property OnCustomFreeData: TQCustomFreeDataEvent read FOnCustomFreeData
      write FOnCustomFreeData;
    /// <summary>��һ���ظ���ҵ����ʱ��</summary>
    property NextRepeatJobTime: Int64 read GetNextRepeatJobTime;
    /// <summary>��ִ����ҵ����ʱ�������Ա㴦���쳣</summayr>
    property OnError: TWorkerErrorNotify read FOnError write FOnError;
    property BeforeExecute: TQJobNotifyEvent read FBeforeExecute
      write FBeforeExecute;
    property AfterExecute: TQJobNotifyEvent read FAfterExecute
      write FAfterExecute;
    property BeforeCancel: TQJobNotifyEvent read FBeforeCancel
      write FBeforeCancel;
    property SignalQueue: TQSignalQueue read FSignalQueue;
    property WorkerExtClass: TQWorkerExtClass read FWorkerExtClass
      write FWorkerExtClass;
    property OnJobFrozen: TQJobProc read FOnJobFrozen write FOnJobFrozen;
  end;
{$IFDEF UNICODE}

  TQJobItemList = TList<PQJob>;
{$ELSE}
  TQJobItemList = TList;
{$ENDIF}

  TQJobGroup = class
  protected
    FEvent: TEvent; // �¼������ڵȴ���ҵ���
    FLocker: TQSimpleLock;
    FItems: TQJobItemList; // ��ҵ�б�
    FPrepareCount: Integer; // ׼������
    FByOrder: Boolean; // �Ƿ�˳�򴥷���ҵ��������ȴ���һ����ҵ��ɺ��ִ����һ��
    FTimeoutCheck: Boolean; // �Ƿ�����ҵ��ʱ
    FAfterDone: TNotifyEvent; // ��ҵ����¼�֪ͨ
    FWaitResult: TWaitResult;
    FRuns: Integer; // �Ѿ����е�����
    FPosted: Integer; // �Ѿ��ύ��QWorkerִ�е�����
    FTag: Pointer;
    FCanceled: Integer;
    FWaitingCount: Integer;
    FRunningWorkers, FMaxWorkers: Integer;
    FFreeAfterDone: Boolean;
    function GetCount: Integer;
    procedure DoJobExecuted(AJob: PQJob);
    procedure DoJobsTimeout(AJob: PQJob);
    procedure DoAfterDone;
    function InitGroupJob(AData: Pointer; AInMainThread: Boolean;
      AFreeType: TQJobDataFreeType): PQJob;
    function InternalAddJob(AJob: PQJob): Boolean;
    function Add(AJob: PQJob): Boolean; overload;
    function InternalInsertJob(AIndex: Integer; AJob: PQJob): Boolean;
    procedure BeginWaiting;
    procedure EndWaiting;
  public
    /// <summary>���캯��</summary>
    /// <param name="AByOrder">ָ���Ƿ���˳����ҵ�����ΪTrue������ҵ�ᰴ����ִ��</param>
    constructor Create(AByOrder: Boolean = false); overload;
    /// <summary>��������</summary>
    destructor Destroy; override;
    /// <summary>ȡ��ʣ��δִ�е���ҵִ��</summary>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ�����ִ�е���ҵִ����ɣ�Ĭ��ΪTrue</param>
    /// <remark>������ڷ��������ҵ�е���Cancel��AWaitRunningDoneһ��Ҫ����ΪFalse��
    /// �������Ҫ�ȴ�����������ִ�е���ҵ��ɣ����������ΪTrue�����򣬿�������ΪFalse</remark>
    procedure Cancel(AWaitRunningDone: Boolean = true);
    /// <summary>Ҫ׼��������ҵ��ʵ�������ڲ�������</summary>
    /// <remarks>Prepare��Run����ƥ��ʹ�ã�������������ҵ���ᱻִ��</remarks>
    procedure Prepare;
    /// <summary>�����ڲ��������������������Ϊ0����ʼʵ��ִ����ҵ</summary>
    /// <param name="ATimeout">�ȴ�ʱ������λΪ����</param>
    procedure Run(ATimeout: Cardinal = INFINITE);
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AIndex">Ҫ����ĵ�λ������</param>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Insert(AIndex: Integer; AProc: TQJobProc; AData: Pointer;
      AInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AIndex">Ҫ����ĵ�λ������</param>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Insert(AIndex: Integer; AProc: TQJobProcG; AData: Pointer;
      AInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AIndex">Ҫ����ĵ�λ������</param>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Insert(AIndex: Integer; AProc: TQJobProcA; AData: Pointer;
      AInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Add(AProc: TQJobProc; AData: Pointer;
      AInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Add(AProc: TQJobProcG; AData: Pointer;
      AInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Add(AProc: TQJobProcA; AData: Pointer;
      AInMainThread: Boolean = false;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>�ȴ���ҵ���</summary>
    /// <param name="ATimeout">��ȴ�ʱ�䣬��λΪ����</param>
    /// <returns>���صȴ����</returns>
    /// <remarks>WaitFor��������ǰ�̵߳�ִ�У���������߳��е��ã�����ʹ��MsgWaitFor
    /// �Ա�֤�������е���ҵ�ܹ���ִ��</remarks>
    function WaitFor(ATimeout: Cardinal = INFINITE): TWaitResult; overload;
    /// <summary>�ȴ���ҵ���</summary>
    /// <param name="ATimeout">��ȴ�ʱ�䣬��λΪ����</param>
    /// <returns>���صȴ����</returns>
    /// <remarks>�����ǰ�����߳���ִ��,MsgWaitFor�����Ƿ�����Ϣ��Ҫ��������
    /// WaitFor���ᣬ����ں�̨�߳���ִ�У���ֱ�ӵ���WaitFor����ˣ������߳��е���
    /// WaitFor��Ӱ�����߳�����ҵ��ִ�У���MsgWaitFor����
    /// </remarks>
    function MsgWaitFor(ATimeout: Cardinal = INFINITE): TWaitResult;
    /// <summary>δ��ɵ���ҵ����</summary>
    property Count: Integer read GetCount;
    /// <summary>ȫ����ҵִ�����ʱ�����Ļص��¼�</summary>
    property AfterDone: TNotifyEvent read FAfterDone write FAfterDone;
    /// <summary>�Ƿ��ǰ�˳��ִ�У�ֻ���ڹ��캯����ָ�����˴�ֻ��</summary>
    property ByOrder: Boolean read FByOrder;
    /// <summary>�û��Զ��ķ��鸽�ӱ�ǩ</summary>
    property Tag: Pointer read FTag write FTag;
    /// <summary>�Ƿ�����ҵ��ɺ��Զ��ͷ�����</summary>
    property FreeAfterDone: Boolean read FFreeAfterDone write FFreeAfterDone;
    /// <summary>��ִ����ɵ���ҵ����</summary>
    property Runs: Integer read FRuns;
    /// <summary>����ͬʱִ�еĹ�����������<=0Ϊ�����ƣ�Ĭ�ϣ�>/summary>
    property MaxWorkers: Integer read FMaxWorkers write FMaxWorkers;
  end;

  TQForJobs = class
  private
    FStartIndex, FStopIndex, FIterator: TForLoopIndexType;
    FBreaked: Integer;
    FEvent: TEvent;
    FWorkerCount: Integer;
    FWorkJob: PQJob;
    procedure DoJob(AJob: PQJob);
    procedure Start;
    function Wait(AMsgWait: Boolean): TWaitResult;
    function GetBreaked: Boolean;
    function GetRuns: Cardinal; inline;
    function GetTotalTime: Cardinal; inline;
    function GetAvgTime: Cardinal; inline;
  public
    constructor Create(const AStartIndex, AStopIndex: TForLoopIndexType;
      AData: Pointer; AFreeType: TQJobDataFreeType = jdfFreeByUser); overload;
    destructor Destroy; override;
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProc; AMsgWait: Boolean = false;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static;
{$IFDEF UNICODE}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcA; AMsgWait: Boolean = false;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static;
{$ENDIF}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcG; AMsgWait: Boolean = false;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static;
    procedure Run(AWorkerProc: TQForJobProc;
      AMsgWait: Boolean = false); overload;
    procedure Run(AWorkerProc: TQForJobProcG;
      AMsgWait: Boolean = false); overload;
{$IFDEF UNICODE}
    procedure Run(AWorkerProc: TQForJobProcA;
      AMsgWait: Boolean = false); overload;
{$ENDIF}
    /// <summary>�ж�ѭ����ִ��</summary>
    procedure BreakIt;
    /// <summary>��ʼ����</summary>
    property StartIndex: TForLoopIndexType read FStartIndex;
    /// <summary>��������</summary>
    property StopIndex: TForLoopIndexType read FStopIndex;
    /// <summary>���ж�</summary>
    property Breaked: Boolean read GetBreaked;
    /// <summary>�����д���<summary>
    property Runs: Cardinal read GetRuns;
    /// <summary>������ʱ�䣬����Ϊ0.1ms</summary>
    property TotalTime: Cardinal read GetTotalTime;
    /// <summary>ƽ��ÿ�ε�����ʱ������Ϊ0.1ms</summary>
    property AvgTime: Cardinal read GetAvgTime;
  end;

type
  TGetThreadStackInfoFunction = function(AThread: TThread): QStringW;
  TMainThreadProc = procedure(AData: Pointer) of object;
  TMainThreadProcG = procedure(AData: Pointer);
  TObjectFreeProc = procedure(AObject: TObject);
  /// <summary>��ȫ�ֵ���ҵ��������ת��ΪTQJobProc���ͣ��Ա���������ʹ��</summary>
  /// <param name="AProc">ȫ�ֵ���ҵ��������</param>
  /// <returns>�����µ�TQJobProcʵ��</returns>
function MakeJobProc(const AProc: TQJobProcG): TMethod; overload;
{$IFDEF UNICODE}
function MakeJobProc(const AProc: TQJobProcA): TMethod; overload;
{$ENDIF}
// ��ȡϵͳ��CPU�ĺ�������
function GetCPUCount: Integer;
// ��ȡ��ǰϵͳ��ʱ�������߿ɾ�ȷ��0.1ms����ʵ���ܲ���ϵͳ����
function GetTimestamp: Int64;
// �����߳����е�CPU
procedure SetThreadCPU(AHandle: THandle; ACpuNo: Integer);
// ԭ������������
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer;
// ԭ������������
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer;
/// <summary>��ȡ��ҵ������л������ҵ��������</summary>
function JobPoolCount: NativeInt;
/// <summary>��ӡ��ҵ���л������ҵ������Ϣ</summary>
function JobPoolPrint: QStringW;
/// <summary>���ָ����ҵ״̬��״̬��Ϣ</summary>
/// <param name="AState">��ҵ״̬</param>
procedure ClearJobState(var AState: TQJobState); inline;
/// <summary>���ָ����ҵ״̬�����״̬��Ϣ</summary>
/// <param name="AStates">��ҵ״̬����</param>
procedure ClearJobStates(var AStates: TQJobStateArray);
/// <summary>�����߳���ִ��ָ���ĺ���</summary>
/// <param name="AProc">Ҫִ�еĺ���</param>
/// <param name="AData">���Ӳ���</param>
procedure RunInMainThread(AProc: TMainThreadProc; AData: Pointer); overload;
/// <summary>�����߳���ִ��ָ���ĺ���</summary>
/// <param name="AProc">Ҫִ�еĺ���</param>
/// <param name="AData">���Ӳ���</param>
procedure RunInMainThread(AProc: TMainThreadProcG; AData: Pointer); overload;
{$IFDEF UNICODE}
/// <summary>�����߳���ִ��ָ���ĺ���</summary>
/// <param name="AProc">Ҫִ�еĺ���</param>
procedure RunInMainThread(AProc: TThreadProcedure); overload;
{$ENDIF}
/// <summary>�ж�ָ���߳�ID��Ӧ�ĺ����Ƿ����</summary>
/// <param name="AThreadId">�߳�ID</param>
/// <param name="AProcessId">����ID�����Ϊ$FFFFFFFF���򲻼�飬���Ϊ0����Ϊ��ǰ����</param>
/// <returns>������ڣ��򷵻�True�����򷵻�False</returns>
function ThreadExists(AThreadId: TThreadId; AProcessId: DWORD = 0): Boolean;
/// <summary>��������Ϣѭ�����ȴ�ĳһ�¼�����</summary>
/// <param name="AEvent">Ҫ�ȴ��������¼�</param>
/// <param name="ATimeout">�ȴ���ʱʱ�䣬��λ����</param>
/// <returns>���صȴ����</returns>
function MsgWaitForEvent(AEvent: TEvent; ATimeout: Cardinal;
  AbortOnAppTerminated: Boolean = false): TWaitResult;
procedure MsgSleep(ATimeout: Cardinal);
function JobParam(const AName: String; const AValue: Variant): TQJobParamPair;
function JobParams(const AParams: array of TQJobParamPair): IQJobNamedParams;
function IsAppTerminated: Boolean;
procedure RegisterClassFreeProc(AType: PTypeInfo; AOnFree: TObjectFreeProc);
/// <summary>��ȡ��ǰ����ִ�е���ҵ�ľ����������ҵ�����Ķ��������л�ȡ��ǰ��ҵ������Ա㼰ʱ�˳�</summary>
/// <returns>���ص�ǰ�߳�����ִ�е���ҵ��������û�У����ؿ�</returns>
function CurrentJob: PQJob;

var
  Workers: TQWorkers;
  GetThreadStackInfo: TGetThreadStackInfoFunction;

implementation

{$IFDEF USE_MAP_SYMBOLS}

uses qmapsymbols;
{$ENDIF}

resourcestring
  SNotSupportNow = '��ǰ��δ֧�ֹ��� %s';
  STooFewWorkers = 'ָ������С����������̫��(������ڵ���1)��';
  SMaxMinWorkersError = 'ָ������С���������������������������';
  STooManyLongtimeWorker = '��������̫�೤ʱ����ҵ�߳�(�������������һ��)��';
  SBadWaitDoneParam = 'δ֪�ĵȴ�����ִ����ҵ��ɷ�ʽ:%d';
  SUnsupportPlatform = '%s ��ǰ�ڱ�ƽ̨����֧�֡�';
  STerminateMainThreadJobInMainThread =
    '�����߳��еȴ����߳���ҵ�������ܻ������ѭ�����뽫 AWaitRunningDone ��������Ϊ false��';

type
{$IFDEF MSWINDOWS}
  TGetTickCount64 = function: Int64;
  TGetSystemTimes = function(var lpIdleTime, lpKernelTime,
    lpUserTime: TFileTime): BOOL; stdcall;
  TOpenThread = function(dwDesiredAccess: DWORD; bInheritHandle: Boolean;
    dwThreadId: DWORD): THandle; stdcall;
{$ENDIF MSWINDOWS}

  TJobPool = class
  protected
    FFirst: PQJob;
    FCount: Integer;
    FSize: Integer;
    FLocker: TQSimpleLock;
  public
    constructor Create(AMaxSize: Integer); overload;
    destructor Destroy; override;
    procedure Push(AJob: PQJob);
    function Pop: PQJob;
    property Count: Integer read FCount;
    property Size: Integer read FSize write FSize;
  end;
{$IF RTLVersion<24}

  TSystemTimes = record
    IdleTime, UserTime, KernelTime, NiceTime: UInt64;
  end;
{$IFEND <XE3}

  TStaticThread = class(TThread)
  protected
    FEvent: TEvent;
    FLastTimes:
{$IF RTLVersion>=24}TThread.{$IFEND >=XE5}TSystemTimes;
    procedure Execute; override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure CheckNeeded;
  end;

  TRunInMainThreadHelper = class
    FProc: TMainThreadProc;
    FData: Pointer;
    procedure Execute;
  end;

  TQJobParams = class(TInterfacedObject, IQJobNamedParams)
  protected
    FParams: array of TQJobParamPair;
    function GetParam(const AIndex: Integer): PQJobParamPair;
    function GetCount: Integer;
    function ValueByName(const AName: String): Variant;
  public
    constructor Create(const AParams: array of TQJobParamPair);
  end;

  TSyncEntryRegister = procedure(const AProc: Pointer); stdcall;
  TCheckSyncProc = function(Timeout: Integer): Boolean;

  TDLLMainThreadSyncHelper = class
  private
    class var FCurrent: TDLLMainThreadSyncHelper;
    class function GetCurrent: TDLLMainThreadSyncHelper; static;
    // procedure CreateTimer;

  var
    HostRegister, HostUnregister: TSyncEntryRegister;
    FMainThreadWakeup: TNotifyEvent;
    FDLLSyncEntries: array of Pointer;
    FWakeupFlags: Integer;
    FTimer: TObject;
{$IFDEF MSWINDOWS}
    FSyncWnd: HWND;
    procedure DoSyncWndProc(var AMsg: TMessage);
{$ENDIF}
    class procedure DoRegister(const AProc: Pointer); stdcall; static;
    class procedure DoUnregister(const AProc: Pointer); stdcall; static;
    procedure DoMainThreadWakeup(Sender: TObject);
    procedure DLLSynchronize;
    procedure HookMainWakeup;
  public
    constructor Create;
    destructor Destroy; override;
    class destructor Destroy;
    class property Current: TDLLMainThreadSyncHelper read GetCurrent;

  end;

  PAbortableEvent = ^TAbortableEvent;

  TAbortableEvent = record
  private
    class var First, Last: PAbortableEvent;
  private
    Prior, Next: PAbortableEvent;
    Event: TEvent;
    Aborted: Boolean;
    procedure InsertWait(AEvent: TEvent);
    procedure RemoveWait;
  public
    function WaitFor(AEvent: TEvent; const ATimeout: Cardinal): TWaitResult;
    procedure AbortWait;
    class procedure AbortAll; static;
  end;

  TObjectFreeEntry = record
    ClassType: PTypeInfo;
    OnFree: TObjectFreeProc;
  end;

  PObjectFreeEntry = ^TObjectFreeEntry;

var
  JobPool: TJobPool;
  _CPUCount: Integer;
  AppTerminated: Boolean;
  ObjectFreeEntries: TList;
{$IFDEF MSWINDOWS}
  GetTickCount64: TGetTickCount64;
  WinGetSystemTimes: TGetSystemTimes;
  OpenThread: TOpenThread;
  _PerfFreq: Int64;
  _StartCounter: Int64;
{$ELSE}
  _Watch: TStopWatch;
{$ENDIF}
{$IFDEF __BORLANDC}
procedure FreeAsCDelete(AData: Pointer); external;
procedure FreeAsCDeleteArray(AData: Pointer); external;
{$ENDIF}

procedure ThreadYield;
begin
{$IFDEF MSWINDOWS}
  SwitchToThread;
{$ELSE}
  TThread.Yield;
{$ENDIF}
end;

function ThreadExists(AThreadId: TThreadId; AProcessId: DWORD): Boolean;
{$IFDEF MSWINDOWS}
  function WinThreadExists: Boolean;
  var
    AHandle: THandle;
  const
    THREAD_QUERY_INFORMATION = $0040;
    THREAD_SUSPEND_RESUME = $0002;
  begin
    AHandle := OpenThread(THREAD_SUSPEND_RESUME, true, AThreadId);
    Result := AHandle <> 0;
    if Result then
    begin
      Result := SuspendThread(AHandle) <> Cardinal(-1); // �߳�����Ѿ���ֹ,���ܿ�������ͣ
      if Result then // �������,��ָ�ִ��(������ȡ���ڼ���)
        ResumeThread(AHandle);
      CloseHandle(AHandle);
    end;
  end;
{$ENDIF}
{$IFDEF POSIX}
  function PosixThreadExists: Boolean;
  var
    P: Integer;
    J: sched_param;
  begin
    Result := pthread_getschedparam(pthread_t(AThreadId), P, J) <> ESRCH;
  end;
{$ENDIF}

begin
{$IFDEF POSIX}
  Result := PosixThreadExists;
{$ELSE}
  Result := WinThreadExists;
{$ENDIF}
end;

function IsAppTerminated: Boolean;
begin
  Result := AppTerminated;
end;

function WaitforAbortableEvent(AEvent: TEvent; ATimeout: DWORD): TWaitResult;
var
  AItem: TAbortableEvent;
begin
  Result := AItem.WaitFor(AEvent, ATimeout);
end;

function DoAppTerminate: Boolean;
begin
  AppTerminated := true;
  Result := true;
  TAbortableEvent.AbortAll;
end;

function ProcessAppMessage: Boolean;
begin
{$IFNDEF CONSOLE}
  Application.ProcessMessages;
  AppTerminated := Application.Terminated;
{$ENDIF}
  Result := not AppTerminated;
end;

procedure MsgSleep(ATimeout: Cardinal);
var
  AEvent: TEvent;
begin
  AEvent := TEvent.Create(nil, false, false, '');
  try
    MsgWaitForEvent(AEvent, ATimeout);
  finally
    FreeAndNil(AEvent);
  end;
end;

function MsgWaitForEvent(AEvent: TEvent; ATimeout: Cardinal;
  AbortOnAppTerminated: Boolean): TWaitResult;
var
  T: Cardinal;
{$IFDEF MSWINDOWS}
  AHandles: array [0 .. 0] of THandle;
  rc: DWORD;
{$ENDIF}
begin
  if GetCurrentThreadId <> MainThreadId then
  begin
    if AbortOnAppTerminated then
      Result := WaitforAbortableEvent(AEvent, ATimeout)
    else
      Result := AEvent.WaitFor(ATimeout);
  end
  else
  begin
{$IFDEF MSWINDOWS}
    Result := wrTimeout;
    AHandles[0] := AEvent.Handle;
    repeat
      T := GetTickCount;
      rc := MsgWaitForMultipleObjects(1, AHandles[0], false, ATimeout,
        QS_ALLINPUT);
      if rc = WAIT_OBJECT_0 + 1 then
      begin
        if ProcessAppMessage then
        begin
          T := GetTickCount - T;
          if ATimeout > T then
            Dec(ATimeout, T)
          else
          begin
            Result := wrTimeout;
            Break;
          end;
        end
        else
        begin
          Result := wrAbandoned;
          Break;
        end;
      end
      else
      begin
        case rc of
          WAIT_ABANDONED:
            Result := wrAbandoned;
          WAIT_OBJECT_0:
            Result := wrSignaled;
          WAIT_TIMEOUT:
            Result := wrTimeout;
          WAIT_FAILED:
            Result := wrError;
          WAIT_IO_COMPLETION:
            Result := wrIOCompletion;
        end;
        Break;
      end;
    until false;
{$ELSE}
    repeat
      // ÿ��10������һ���Ƿ�����Ϣ��Ҫ�����������������������һ���ȴ�
      T := GetTimestamp;
      if ProcessAppMessage then
      begin
        Result := AEvent.WaitFor(10);
        if Result = wrTimeout then
        begin
          T := (GetTimestamp - T) div 10;
          if ATimeout > T then
            Dec(ATimeout, T)
          else
            Break;
        end
        else
          Break;
      end
      else
      begin
        Result := wrAbandoned;
        Break;
      end;
    until false;
{$ENDIF}
  end;
end;

function JobParam(const AName: String; const AValue: Variant): TQJobParamPair;
begin
  Result.Name := AName;
  Result.Value := AValue;
end;

function JobParams(const AParams: array of TQJobParamPair): IQJobNamedParams;
begin
  Result := TQJobParams.Create(AParams);
end;

procedure ClearJobState(var AState: TQJobState);
begin
{$IFDEF UNICODE}
  if (AState.Proc.Data = Pointer(-1)) then
    TQJobProcA(AState.Proc.ProcA) := nil;
{$ENDIF}
  if IsFMXApp then
  begin
    AState.Proc.Code := nil;
    AState.Proc.Data := nil;
  end;
end;
{$IFDEF UNICODE}

function GetFunctionObject(ACode: IInterface): Pointer;
var
  AObj: TObject;
  AType: TRttiType;
  AField: TRttiField;
  AValue: TValue;
begin
  AObj := ACode as TObject;
  AType := TRttiContext.Create.GetType(AObj.ClassType.ClassInfo);
  Result := nil;
  if Assigned(AType) then
  begin
    DebugOut('Method interface is %s', [AObj.ClassName]);
    // ����Ƿ���Self��Ա������У�˵���ǹ���������ģ�����˵���ο���http://blog.qdac.cc/?p=5435
    AField := AType.GetField('Self');
    if Assigned(AField) then
    begin
      AValue := AField.GetValue(AObj);
      if AValue.IsObject then
        Result := AValue.AsObject
      else // Delphi ����������֧���ڼ�¼�е��ã��������������Ϊ��
        Result := nil;
    end;
  end;
end;
{$ENDIF}

function IsObjectJob(AJob: PQJob; AData: Pointer): Boolean;
begin
  Result := (AJob.WorkerProc.Data = AData) or
    (AJob.IsGrouped and (AJob.Group = AData));
{$IFDEF UNICODE}
  // ������������Ƿ�������˶���
  if (not Result) and (AJob.WorkerProc.Data = INVALID_JOB_DATA) then
    Result := GetFunctionObject(IInterface(AJob.WorkerProc.Code)) = AData;
{$ENDIF}
end;

procedure ClearJobStates(var AStates: TQJobStateArray);
var
  I: Integer;
begin
  for I := 0 to High(AStates) do
    ClearJobState(AStates[I]);
  SetLength(AStates, 0);
end;

procedure JobInitialize(AJob: PQJob; AData: Pointer;
  AFreeType: TQJobDataFreeType; ARunOnce, ARunInMainThread: Boolean); inline;
begin
  AJob.Data := AData;
  if AData <> nil then
  begin
    AJob.Flags := AJob.Flags or (Integer(AFreeType) shl 8);
    if AFreeType = jdfFreeAsInterface then
      (IInterface(AData) as IInterface)._AddRef
    else if AFreeType = jdfFreeAsParams then
      IQJobNamedParams(AData)._AddRef
{$IFDEF AUTOREFCOUNT}
      // �ƶ�ƽ̨��AData�ļ�����Ҫ���ӣ��Ա����Զ��ͷ�
    else if AFreeType = jdfFreeAsObject then
      TObject(AData).__ObjAddRef;
{$ENDIF}
    ;
  end;
  AJob.SetFlags(JOB_RUN_ONCE, ARunOnce);
  AJob.SetFlags(JOB_IN_MAINTHREAD, ARunInMainThread);
end;

// λ�룬����ԭֵ
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  I: Integer;
begin
  repeat
    Result := Dest;
    I := Result and AMask;
  until AtomicCmpExchange(Dest, I, Result) = Result;
end;

// λ�򣬷���ԭֵ
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  I: Integer;
begin
  repeat
    Result := Dest;
    I := Result or AMask;
  until AtomicCmpExchange(Dest, I, Result) = Result;
end;

procedure SetThreadCPU(AHandle: THandle; ACpuNo: Integer);
begin
{$IFDEF MSWINDOWS}
  SetThreadIdealProcessor(AHandle, ACpuNo);
{$ELSE}
  // Linux/Andriod/iOS��ʱ����,XE6δ����sched_setaffinity����,ɶʱ�������ټ���֧��
{$ENDIF}
end;

// ����ֵ��ʱ�侫��Ϊ100ns����0.1ms
function GetTimestamp: Int64;
begin
{$IFDEF MSWINDOWS}
  if _PerfFreq > 0 then
  begin
    QueryPerformanceCounter(Result);
    Result := Trunc((Result - _StartCounter) / _PerfFreq * 10000);
  end
  else if Assigned(GetTickCount64) then
    Result := (GetTickCount64 - _StartCounter) * 10
  else
    Result := (GetTickCount - _StartCounter) * 10;
{$ELSE}
  Result := _Watch.Elapsed.Ticks div 1000;
{$ENDIF}
end;

function GetCPUCount: Integer;
{$IFDEF MSWINDOWS}
var
  si: SYSTEM_INFO;
{$ENDIF}
begin
  if _CPUCount = 0 then
  begin
{$IFDEF MSWINDOWS}
    GetSystemInfo(si);
    Result := si.dwNumberOfProcessors;
{$ELSE}// Linux,MacOS,iOS,Andriod{POSIX}
{$IFDEF POSIX}
{$WARN SYMBOL_PLATFORM OFF}
    Result := sysconf(_SC_NPROCESSORS_ONLN);
{$WARN SYMBOL_PLATFORM ON}
{$ELSE}// ����ʶ�Ĳ���ϵͳ��CPU��Ĭ��Ϊ1
    Result := 1;
{$ENDIF !POSIX}
{$ENDIF !MSWINDOWS}
  end
  else
    Result := _CPUCount;
end;

function MakeJobProc(const AProc: TQJobProcG): TMethod;
begin
  Result.Data := nil;
  Result.Code := @AProc;
end;

function FindClassFreeProc(ATypeInfo: PTypeInfo; var AIndex: Integer)
  : TObjectFreeProc;
var
  L, H, I, C: Integer;
begin
  Result := nil;
  L := 0;
  GlobalNameSpace.BeginRead;
  try
    H := ObjectFreeEntries.Count - 1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := IntPtr(PObjectFreeEntry(ObjectFreeEntries[I]).ClassType) -
        IntPtr(ATypeInfo);
      if C < 0 then
        L := I + 1
      else
      begin
        H := I - 1;
        if C = 0 then
        begin
          Result := PObjectFreeEntry(ObjectFreeEntries[I]).OnFree;
          AIndex := I;
          Exit;
        end;
      end;
    end;
    AIndex := L;
  finally
    GlobalNameSpace.EndRead;
  end;
end;

procedure RegisterClassFreeProc(AType: PTypeInfo; AOnFree: TObjectFreeProc);
var
  I: Integer;
  AItem: PObjectFreeEntry;
  AExists: TObjectFreeProc;
begin
  GlobalNameSpace.BeginWrite;
  try
    AExists := FindClassFreeProc(AType, I);
    if not Assigned(AExists) then
    begin
      New(AItem);
      AItem.ClassType := AType;
      AItem.OnFree := AOnFree;
      ObjectFreeEntries.Insert(I, AItem);
    end;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

procedure CleanupFreeProcs;
var
  I: Integer;
begin
  for I := 0 to ObjectFreeEntries.Count - 1 do
    Dispose(PObjectFreeEntry(ObjectFreeEntries[I]));
  FreeAndNil(ObjectFreeEntries);
end;

function CurrentJob: PQJob;
begin
  if TThread.CurrentThread is TQWorker then
    Result := TQWorker(TThread.CurrentThread).FActiveJob
  else if GetCurrentThreadId <> MainThreadId then
    Result := TQWorker.FMainThreadJob
  else
    Result := nil;
end;

{$IFDEF UNICODE}

function MakeJobProc(const AProc: TQJobProcA): TMethod;
var
  AMethod: TMethod absolute Result;
begin
  AMethod.Data := Pointer(-1);
  AMethod.Code := nil;
  TQJobProcA(AMethod.Code) := AProc;
end;
{$ENDIF}

function SameWorkerProc(const P1: TQJobMethod; P2: TQJobProc): Boolean; inline;
begin
  Result := (P1.Code = TMethod(P2).Code) and (P1.Data = TMethod(P2).Data);
end;
{ TQJob }

procedure TQJob.AfterRun(AUsedTime: Int64);
begin
  Inc(Runs);
  if AUsedTime > 0 then
  begin
    Inc(TotalUsedTime, AUsedTime);
    if MinUsedTime = 0 then
      MinUsedTime := AUsedTime
    else if MinUsedTime > AUsedTime then
      MinUsedTime := AUsedTime;
    if MaxUsedTime = 0 then
      MaxUsedTime := AUsedTime
    else if MaxUsedTime < AUsedTime then
      MaxUsedTime := AUsedTime;
  end;
end;

procedure TQJob.Assign(const ASource: PQJob);
begin
  Self := ASource^;
{$IFDEF UNICODE}
  if IsAnonWorkerProc then
  begin
    WorkerProc.ProcA := nil;
    TQJobProcA(WorkerProc.ProcA) := TQJobProcA(ASource.WorkerProc.ProcA);
  end;
{$ENDIF}
  // �����Ա������
  Worker := nil;
  Next := nil;
end;

constructor TQJob.Create(AProc: TQJobProc);
begin
{$IFDEF NEXTGEN}
  PQJobProc(@WorkerProc)^ := AProc;
{$ELSE}
  WorkerProc.Proc := AProc;
{$ENDIF}
  SetFlags(JOB_RUN_ONCE, true);
end;

function TQJob.GetAvgTime: Integer;
begin
  if Runs > 0 then
    Result := TotalUsedTime div Cardinal(Runs)
  else
    Result := 0;
end;

function TQJob.GetIsAnonWorkerProc: Boolean;
begin
  Result := (WorkerProc.Data = Pointer(-1));
end;

function TQJob.GetIsCustomFree: Boolean;
begin
  Result := FreeType in [jdfFreeAsC1 .. jdfFreeAsC6];
end;

function TQJob.GetIsInterfaceOwner: Boolean;
begin
  Result := (FreeType in [jdfFreeAsInterface, jdfFreeAsParams]);
end;

function TQJob.GetIsObjectOwner: Boolean;
begin
  Result := (FreeType = jdfFreeAsObject);
end;

function TQJob.GetIsPlanRunning: Boolean;
begin
  if IsByPlan then
    Result := ExtData.AsPlan.Runnings > 0
  else
    Result := false;
end;

function TQJob.GetIsRecordOwner: Boolean;
begin
  Result := (FreeType = jdfFreeAsSimpleRecord);
end;

function TQJob.GetIsTerminated: Boolean;
begin
  if Assigned(Worker) then
    Result := Workers.Terminating or Worker.Terminated or
      ((Flags and JOB_TERMINATED) <> 0) or (Worker.FTerminatingJob = @Self)
  else
    Result := (Flags and JOB_TERMINATED) <> 0;
end;

function TQJob.GetParams: IQJobNamedParams;
begin
  if FreeType = jdfFreeAsParams then
    Result := IQJobNamedParams(Data)
  else if IsSignalWakeup and
    (PQSignalQueueItem(SignalData).FreeType = jdfFreeAsParams) then
    Result := IQJobNamedParams(PQSignalQueueItem(SignalData).Data)
  else
    Result := nil;
end;

function TQJob.GetElapsedTime: Int64;
begin
  Result := GetTimestamp - StartTime;
end;

function TQJob.GetExtData: TQJobExtData;
begin
  Result := Data;
end;

function TQJob.GetFlags(AIndex: Integer): Boolean;
begin
  Result := (Flags and AIndex) <> 0;
end;

function TQJob.GetFreeType: TQJobDataFreeType;
begin
  Result := TQJobDataFreeType((Flags shr 8) and $0F);
end;

function TQJob.GetHandle: IntPtr;
var
  AMask: IntPtr;
begin
  if IsSignalWakeup then
  begin
    AMask := JOB_HANDLE_SIGNAL_MASK;
    if Assigned(Source) then
      Result := IntPtr(Source) or AMask
    else
      Result := IntPtr(@Self) or AMask;
  end
  else
  begin
    if IsByPlan then
      AMask := JOB_HANDLE_PLAN_MASK
    else if (FirstDelay <> 0) or (not Runonce) then
      AMask := JOB_HANDLE_REPEAT_MASK
    else
      AMask := JOB_HANDLE_SIMPLE_MASK;
    Result := IntPtr(@Self) or AMask;
  end;
end;

procedure TQJob.Reset;
begin

  FillChar(Self, SizeOf(TQJob), 0);
end;

procedure TQJob.SetFlags(AIndex: Integer; AValue: Boolean);
begin
  if AValue then
    Flags := (Flags or AIndex)
  else
    Flags := (Flags and (not AIndex));
end;

procedure TQJob.SetFreeType(const Value: TQJobDataFreeType);
begin
  Flags := (Flags and (not JOB_DATA_OWNER)) or (Integer(Value) shl 8);
end;

procedure TQJob.SetIsTerminated(const Value: Boolean);
begin
  SetFlags(JOB_TERMINATED, Value);
end;
{$IFDEF UNICODE}

procedure TQJob.Synchronize(AProc: TThreadProcedure);
begin
  if GetCurrentThreadId = MainThreadId then
    AProc
  else
    Worker.Synchronize(AProc);
end;
{$ENDIF}

procedure TQJob.Synchronize(AMethod: TThreadMethod);
begin
  if GetCurrentThreadId = MainThreadId then
    AMethod
  else
    Worker.Synchronize(AMethod);
end;

procedure TQJob.UpdateNextTime;
begin
  if IsDelayRepeat then
    NextTime := GetTimestamp + FirstDelay
  else if (Runs = 0) and (FirstDelay <> 0) then
    NextTime := PushTime + FirstDelay
  else if Interval <> 0 then
  begin
    if NextTime = 0 then
      NextTime := GetTimestamp + Interval
    else
      Inc(NextTime, Interval);
  end
  else
    NextTime := GetTimestamp;
end;

{ TQSimpleJobs }

function TQSimpleJobs.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
begin
  // �Ƚ�SimpleJobs���е��첽��ҵ��գ��Է�ֹ������ִ��
  AJob := PopAll;
  Result := 0;
  APrior := nil;
  AFirst := nil;
  while (AJob <> nil) and (AMaxTimes <> 0) do
  begin
    ANext := AJob.Next;
    if IsObjectJob(AJob, AObject) and (not AJob.IsPlanRunning) then
    begin
      if APrior <> nil then
        APrior.Next := ANext
      else // �׸�
        AFirst := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Dec(AMaxTimes);
      Inc(Result);
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

function TQSimpleJobs.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
begin
  AJob := PopAll;
  Result := 0;
  APrior := nil;
  AFirst := nil;
  while (AJob <> nil) and (AMaxTimes <> 0) do
  begin
    ANext := AJob.Next;
    if SameWorkerProc(AJob.WorkerProc, AProc) and (not AJob.IsPlanRunning) and
      ((AJob.Data = AData) or (AData = INVALID_JOB_DATA)) then
    begin
      if APrior <> nil then
        APrior.Next := ANext
      else // �׸�
        AFirst := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Dec(AMaxTimes);
      Inc(Result);
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

procedure TQSimpleJobs.Clear;
var
  AFirst: PQJob;
begin
  FLocker.Enter;
  AFirst := FFirst;
  FFirst := nil;
  FLast := nil;
  FCount := 0;
  FLocker.Leave;
  FOwner.FreeJob(AFirst);
end;

function TQSimpleJobs.Clear(AHandle: IntPtr): Boolean;
var
  AFirst, AJob, APrior, ANext: PQJob;
begin
  AJob := PopAll;
  Result := false;
  APrior := nil;
  AFirst := nil;
  while AJob <> nil do
  begin
    ANext := AJob.Next;
    if (IntPtr(AJob) = AHandle) and (not AJob.IsPlanRunning) then
    begin
      if APrior <> nil then
        APrior.Next := ANext
      else // �׸�
        AFirst := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Result := true;
      Break;
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

constructor TQSimpleJobs.Create(AOwner: TQWorkers);
begin
  inherited Create(AOwner);
  FLocker := TQSimpleLock.Create;
end;

destructor TQSimpleJobs.Destroy;
begin
  inherited;
  FreeObject(FLocker);
end;

function TQSimpleJobs.GetCount: Integer;
begin
  Result := FCount;
end;

function TQSimpleJobs.InternalPop: PQJob;
begin
  FLocker.Enter;
  Result := FFirst;
  if Result <> nil then
  begin
    FFirst := Result.Next;
    if FFirst = nil then
      FLast := nil;
    Dec(FCount);
  end;
  FLocker.Leave;
end;

function TQSimpleJobs.InternalPush(AJob: PQJob): Boolean;
begin
  FLocker.Enter;
  if AJob.AsFirst then
  begin
    AJob.Next := FFirst;
    FFirst := AJob;
    if not Assigned(FLast) then
      FLast := AJob;
  end
  else
  begin
    if FLast = nil then
      FFirst := AJob
    else
      FLast.Next := AJob;
    FLast := AJob;
  end;
  Inc(FCount);
  FLocker.Leave;
  Result := true;
end;

function TQSimpleJobs.PopAll: PQJob;
begin
  FLocker.Enter;
  Result := FFirst;
  FFirst := nil;
  FLast := nil;
  FCount := 0;
  FLocker.Leave;
end;

procedure TQSimpleJobs.Repush(ANewFirst: PQJob);
var
  ALast: PQJob;
  ACount: Integer;
begin
  if ANewFirst <> nil then
  begin
    ALast := ANewFirst;
    ACount := 1;
    while ALast.Next <> nil do
    begin
      ALast := ALast.Next;
      Inc(ACount);
    end;
    FLocker.Enter;
    ALast.Next := FFirst;
    FFirst := ANewFirst;
    if FLast = nil then
      FLast := ALast;
    Inc(FCount, ACount);
    FLocker.Leave;
  end;
end;

function TQSimpleJobs.ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
  // AHandleEof: PIntPtr;
  function Accept(AJob: PQJob): Boolean;
  var
    P: PIntPtr;
  begin
    P := AHandles;
    Result := false;
    while IntPtr(P) < IntPtr(AHandles) do
    begin
      if (IntPtr(P^) and (not $03)) = IntPtr(AJob) then
      begin
        P^ := 0; // �ÿ�
        Result := true;
        Exit;
      end;
      Inc(P);
    end;
  end;

begin
  AJob := PopAll;
  Result := 0;
  APrior := nil;
  AFirst := nil;
  // AHandleEof := AHandles;
  // Inc(AHandleEof, ACount);
  while AJob <> nil do
  begin
    ANext := AJob.Next;
    if Accept(AJob) then
    begin
      if APrior <> nil then
        APrior.Next := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Inc(Result);
      Break;
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

{ TQJobs }

procedure TQJobs.Clear;
var
  AItem: PQJob;
begin
  repeat
    AItem := Pop;
    if AItem <> nil then
      FOwner.FreeJob(AItem)
    else
      Break;
  until 1 > 2;
end;

function TQJobs.Clear(AHandle: IntPtr): Boolean;
begin
  Result := ClearJobs(@AHandle, 1) = 1;
end;

constructor TQJobs.Create(AOwner: TQWorkers);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TQJobs.Destroy;
begin
  Clear;
  inherited;
end;

function TQJobs.GetEmpty: Boolean;
begin
  Result := (Count = 0);
end;

function TQJobs.Pop: PQJob;
begin
  Result := InternalPop;
  if Result <> nil then
  begin
    Result.PopTime := GetTimestamp;
    Result.Next := nil;
  end;
end;

function TQJobs.Push(AJob: PQJob): Boolean;
begin
  // Assert(AJob.WorkerProc.Code<>nil);
  AJob.Owner := Self;
  AJob.PushTime := GetTimestamp;
  Result := InternalPush(AJob);
  if not Result then
  begin
    AJob.Next := nil;
    FOwner.FreeJob(AJob);
  end;
end;

{ TQRepeatJobs }

procedure TQRepeatJobs.Clear;
begin
  FLocker.Enter;
  try
    FItems.Clear;
    FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  ANode, ANext: TQRBNode;
  APriorJob, AJob, ANextJob: PQJob;
  ACanDelete: Boolean;
begin
  // ��������ظ��ļƻ���ҵ
  Result := 0;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while (ANode <> nil) and (AMaxTimes <> 0) do
    begin
      ANext := ANode.Next;
      AJob := ANode.Data;
      ACanDelete := true;
      APriorJob := nil;
      while AJob <> nil do
      begin
        ANextJob := AJob.Next;
        if IsObjectJob(AJob, AObject) then
        begin
          if ANode.Data = AJob then
            ANode.Data := AJob.Next;
          if Assigned(APriorJob) then
            APriorJob.Next := AJob.Next;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          Dec(AMaxTimes);
          Inc(Result);
        end
        else
        begin
          ACanDelete := false;
          APriorJob := AJob;
        end;
        AJob := ANextJob;
      end;
      if ACanDelete then
        FItems.Delete(ANode);
      ANode := ANext;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

procedure TQRepeatJobs.AfterJobRun(AJob: PQJob; AUsedTime: Int64);
var
  ANode: TQRBNode;
  AWorkerLookupNeeded: Boolean;
  function UpdateSource: Boolean;
  var
    ATemp, APrior: PQJob;
  begin
    Result := false;
    ATemp := ANode.Data;
    APrior := nil;
    while ATemp <> nil do
    begin
      if ATemp = AJob.Source then
      begin
        if AJob.IsTerminated then
        begin
          if APrior <> nil then
            APrior.Next := ATemp.Next
          else
            ANode.Data := ATemp.Next;
          ATemp.Next := nil;
          FOwner.FreeJob(ATemp);
          if ANode.Data = nil then
            FItems.Delete(ANode);
        end
        else
        begin
          ATemp.AfterRun(AUsedTime);
          if ATemp.IsDelayRepeat then
          begin
            if APrior <> nil then
              APrior.Next := ATemp.Next
            else
              ANode.Data := ATemp.Next;
            if ANode.Data = nil then
              FItems.Delete(ANode);
            ATemp.Next := nil;
            InternalPush(ATemp);
            AWorkerLookupNeeded := true;
          end;
        end;
        Result := true;
        Break;
      end;
      APrior := ATemp;
      ATemp := ATemp.Next;
    end;
  end;

begin
  AWorkerLookupNeeded := false;
  FLocker.Enter;
  try
    ANode := FItems.Find(AJob);
    if ANode <> nil then
    begin
      if UpdateSource then
        Exit;
    end;
    ANode := FItems.First;
    while ANode <> nil do
    begin
      if UpdateSource then
        Break;
      ANode := ANode.Next;
    end;
  finally
    FLocker.Leave;
    if AWorkerLookupNeeded then
      FOwner.LookupIdleWorker(false);
  end;
end;

function TQRepeatJobs.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  AJob, APrior, ANext: PQJob;
  ANode, ANextNode: TQRBNode;
begin
  Result := 0;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while (ANode <> nil) and (AMaxTimes <> 0) do
    begin
      AJob := ANode.Data;
      APrior := nil;
      repeat
        if SameWorkerProc(AJob.WorkerProc, AProc) and
          ((AData = INVALID_JOB_DATA) or (AData = AJob.Data)) then
        begin
          ANext := AJob.Next;
          if APrior = nil then
            ANode.Data := ANext
          else
            APrior.Next := AJob.Next;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          AJob := ANext;
          Dec(AMaxTimes);
          Inc(Result);
        end
        else
        begin
          APrior := AJob;
          AJob := AJob.Next
        end;
      until AJob = nil;
      if ANode.Data = nil then
      begin
        ANextNode := ANode.Next;
        FItems.Delete(ANode);
        ANode := ANextNode;
      end
      else
        ANode := ANode.Next;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

constructor TQRepeatJobs.Create(AOwner: TQWorkers);
begin
  inherited;
  FItems := TQRBTree.Create(DoTimeCompare);
  FItems.OnDelete := DoJobDelete;
  FLocker := TCriticalSection.Create;
end;

destructor TQRepeatJobs.Destroy;
begin
  inherited;
  FreeObject(FItems);
  FreeObject(FLocker);
end;

procedure TQRepeatJobs.DoJobDelete(ATree: TQRBTree; ANode: TQRBNode);
begin
  FOwner.FreeJob(ANode.Data);
end;

function TQRepeatJobs.DoTimeCompare(P1, P2: Pointer): Integer;
var
  ATemp: Int64;
begin
  ATemp := PQJob(P1).NextTime - PQJob(P2).NextTime;
  if ATemp < 0 then
    Result := -1
  else if ATemp > 0 then
    Result := 1
  else
    Result := 0;
end;

function TQRepeatJobs.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQRepeatJobs.InternalPop: PQJob;
var
  ANode: TQRBNode;
  ATick: Int64;
  AJob: PQJob;
begin
  Result := nil;
  if FItems.Count = 0 then
    Exit;
  FLocker.Enter;
  try
    if FItems.Count > 0 then
    begin
      ATick := GetTimestamp;
      ANode := FItems.First;
      AJob := ANode.Data;
      // OutputDebugString(PWideChar('Result.NextTime='+IntToStr(AJob.NextTime)+',Current='+IntToStr(ATick)+',Delta='+IntToStr(AJob.NextTime-ATick)));
      if AJob.NextTime <= ATick then
      begin
        if AJob.Next <> nil then
          // ���û�и�����Ҫִ�е���ҵ����ɾ����㣬����ָ����һ��
          ANode.Data := AJob.Next
        else
        begin
          ANode.Data := nil;
          FItems.Delete(ANode);
          ANode := FItems.First;
          if ANode <> nil then
            FFirstFireTime := PQJob(ANode.Data).NextTime
          else
            // û�мƻ���ҵ�ˣ�����Ҫ��
            FFirstFireTime := 0;
        end;
        AJob.PopTime := ATick;
        if AJob.Runonce then
          Result := AJob
        else
        begin
          AJob.Next := nil;
          Result := JobPool.Pop;
          Result.Assign(AJob);
          Result.Source := AJob;
          if AJob.IsDelayRepeat then // �����ҵ���ӳ��ظ���ҵ����֤�����ں���
            AJob.NextTime := JOB_TIME_DELAY
          else
            Inc(AJob.NextTime, AJob.Interval);
          // ���²�����ҵ
          ANode := FItems.Find(AJob);
          if ANode = nil then
          begin
            FItems.Insert(AJob);
            FFirstFireTime := PQJob(FItems.First.Data).NextTime;
          end
          else
          // ����Ѿ�����ͬһʱ�̵���ҵ�����Լ��ҽӵ�������ҵͷ��
          begin
            AJob.Next := PQJob(ANode.Data);
            ANode.Data := AJob; // �׸���ҵ��Ϊ�Լ�
          end;
        end;
      end;
    end
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.InternalPush(AJob: PQJob): Boolean;
var
  ANode: TQRBNode;
begin
  // ������ҵ���´�ִ��ʱ��
  AJob.UpdateNextTime;
  FLocker.Enter;
  try
    ANode := FItems.Find(AJob);
    if ANode = nil then
    begin
      FItems.Insert(AJob);
      FFirstFireTime := PQJob(FItems.First.Data).NextTime;
    end
    else
    // ����Ѿ�����ͬһʱ�̵���ҵ�����Լ��ҽӵ�������ҵͷ������������ͨ�����ĺ������ʵ�����Ż�����һ�β�ѯ
    begin
      AJob.Next := PQJob(ANode.Data);
      ANode.Data := AJob; // �׸���ҵ��Ϊ�Լ�
    end;
    Result := true;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.Clear(AHandle: IntPtr): Boolean;
var
  ANode, ANext: TQRBNode;
  APriorJob, AJob, ANextJob: PQJob;
  ACanDelete: Boolean;
begin
  Result := false;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while ANode <> nil do
    begin
      ANext := ANode.Next;
      AJob := ANode.Data;
      ACanDelete := true;
      APriorJob := nil;
      while AJob <> nil do
      begin
        ANextJob := AJob.Next;
        if IntPtr(AJob) = AHandle then
        begin
          if ANode.Data = AJob then
          begin
            ANode.Data := ANextJob;
            Assert(APriorJob = nil);
          end;
          if Assigned(APriorJob) then
            APriorJob.Next := ANextJob;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          Result := true;
          Break;
        end
        else
        begin
          ACanDelete := false;
          APriorJob := AJob;
        end;
        AJob := ANextJob;
      end;
      if ACanDelete then
        FItems.Delete(ANode);
      ANode := ANext;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
var
  ANode, ANext: TQRBNode;
  APriorJob, AJob, ANextJob: PQJob;
  ACanDelete: Boolean;
  function Accept(AJob: PQJob): Boolean;
  var
    P: PIntPtr;
  begin
    P := AHandles;
    Result := false;
    while IntPtr(P) < IntPtr(AHandles) do
    begin
      if (IntPtr(P^) and (not $03)) = IntPtr(AJob) then
      begin
        P^ := 0;
        Result := true;
        Exit;
      end;
      Inc(P);
    end;
  end;

begin
  Result := 0;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while ANode <> nil do
    begin
      ANext := ANode.Next;
      AJob := ANode.Data;
      ACanDelete := true;
      APriorJob := nil;
      while AJob <> nil do
      begin
        ANextJob := AJob.Next;
        if Accept(AJob) then
        begin
          if ANode.Data = AJob then
            ANode.Data := ANextJob;
          if Assigned(APriorJob) then
            APriorJob.Next := ANextJob;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          Inc(Result);
        end
        else
        begin
          ACanDelete := false;
          APriorJob := AJob;
        end;
        AJob := ANextJob;
      end;
      if ACanDelete then
        FItems.Delete(ANode);
      ANode := ANext;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

{ TQWorker }

procedure TQWorker.AfterExecute;
begin
  Inc(FProcessed);
  FActiveJob.DoneTime := GetTimestamp;
  if Assigned(FOwner.FAfterExecute) then
  begin
    try
      FOwner.FAfterExecute(FActiveJob);
    except

    end;
  end;
  SetFlags(WORKER_CLEANING, true);
{$IFDEF DEBUGOUT}
  OutputDebugString(PChar(FThreadName + ':��ҵ��ɣ�ִ����������'));
{$ENDIF}
  FActiveJob.Worker := nil;
  if not FActiveJob.Runonce then
  begin
    if FActiveJob.IsByPlan then
      FOwner.AfterPlanRun(FActiveJob, GetTimestamp - FActiveJob.StartTime)
    else
      FOwner.FRepeatJobs.AfterJobRun(FActiveJob,
        GetTimestamp - FActiveJob.StartTime);
    FActiveJob.Data := nil;
  end
  else
  begin
    if FActiveJob.IsSignalWakeup then
      FOwner.SignalWorkDone(FActiveJob, GetTimestamp - FActiveJob.StartTime)
    else if FActiveJob.IsLongtimeJob then
      AtomicDecrement(FOwner.FLongTimeWorkers)
    else if FActiveJob.IsGrouped then
      FActiveJobGroup.DoJobExecuted(FActiveJob);
  end;
  if Assigned(FActiveJob) then
    FOwner.FreeJob(FActiveJob);
  FActiveJobProc.Code := nil;
  FActiveJobProc.Data := nil;
  FActiveJobSource := nil;
  FActiveJobFlags := 0;
  FActiveJobGroup := nil;
  FTerminatingJob := nil;
  FFlags := FFlags and (not(WORKER_EXECUTING or WORKER_CLEANING));
end;

procedure TQWorker.ComNeeded(AInitFlags: Cardinal);
begin
{$IFDEF MSWINDOWS}
  if not ComInitialized then
  begin
    if AInitFlags = 0 then
      CoInitialize(nil)
    else
      CoInitializeEx(nil, AInitFlags);
    FFlags := FFlags or WORKER_COM_INITED;
  end;
{$ENDIF MSWINDOWS}
end;

constructor TQWorker.Create(AOwner: TQWorkers);
begin
  inherited Create(true);
  FOwner := AOwner;
  FTimeout := 1000;
  FreeOnTerminate := true;
  FEvent := TEvent.Create(nil, false, false, '');
  FSyncEvent := TEvent.Create(nil, false, false, '');
end;

destructor TQWorker.Destroy;
begin
  FreeAndNil(FSyncEvent);
  FreeAndNil(FEvent);
  if Assigned(FExtObject) then
    FreeAndNil(FExtObject);
  inherited;
end;

procedure TQWorker.DoJob(AJob: PQJob);
begin
{$IFDEF UNICODE}
  if AJob.IsAnonWorkerProc then
    TQJobProcA(AJob.WorkerProc.ProcA)(AJob)
  else
{$ENDIF}
  begin
    if AJob.WorkerProc.Data <> nil then
{$IFDEF NEXTGEN}
      PQJobProc(@AJob.WorkerProc)^(AJob)
{$ELSE}
      AJob.WorkerProc.Proc(AJob)
{$ENDIF}
    else
      AJob.WorkerProc.ProcG(AJob);
  end;
end;

function TQWorker.WaitSignal(ATimeout: Cardinal; AByRepeatJob: Boolean)
  : TWaitResult;
var
  T: Int64;
begin
  if ATimeout > 1 then
  begin
    T := GetTimestamp;
    if Cardinal(ATimeout) > FOwner.FFireTimeout + FFireDelay - FTimeout then
      ATimeout := FOwner.FFireTimeout + FFireDelay - FTimeout;
    Result := FEvent.WaitFor(ATimeout);
    T := GetTimestamp - T;
    if Result = wrTimeout then
    begin
      Inc(FTimeout, T div 10);
      if AByRepeatJob then
        Result := wrSignaled;
    end;
  end
  else
    Result := wrSignaled;
end;

procedure TQWorker.Execute;
var
  wr: TWaitResult;
  ATimestamp, ANextTimestamp: Int64;
begin
{$IFDEF MSWINDOWS}
{$IF RTLVersion>=21}
  FThreadName := IntToHex(IntPtr(HInstance), SizeOf(Pointer) shl 1) +
    '.QWorker.' + IntToStr(ThreadId);
  NameThreadForDebugging(FThreadName);
{$IFEND >=2010}
{$ENDIF}
  try
    SetFlags(WORKER_RUNNING, true);
    FLastActiveTime := GetTimestamp;
    FFireDelay := Random(FOwner.FFireTimeout shr 1);
{$IFDEF DEBUGOUT}
    OutputDebugString(PChar(FThreadName + ':������׼��������ҵ'));
{$ENDIF}
    while not(Terminated or FOwner.FTerminating) do
    begin
      SetFlags(WORKER_CLEANING, false);
{$IFDEF DEBUGOUT}
      OutputDebugString(PChar(FThreadName + ' :���������ڵȴ���ҵ'));
{$ENDIF}
      if FOwner.Enabled then
      begin
        if FOwner.FSimpleJobs.FFirst <> nil then
          wr := wrSignaled
        else
        begin
          ANextTimestamp := FOwner.FRepeatJobs.FFirstFireTime;
          if (ANextTimestamp <> 0) and (ANextTimestamp <> JOB_TIME_DELAY) then
          begin
            ATimestamp := GetTimestamp;
            if ATimestamp >= ANextTimestamp then
              wr := wrSignaled
            else
              wr := WaitSignal((ANextTimestamp - ATimestamp) div 10, true)
          end
          else
            wr := WaitSignal(FOwner.FFireTimeout, false);
        end;
      end
      else
      begin
        WaitSignal(FOwner.FFireTimeout, false);
        continue;
      end;
      if Terminated or FOwner.FTerminating then
      begin
{$IFDEF DEBUGOUT}
        OutputDebugString(PChar(FThreadName + ':�����߼�������'));
{$ENDIF}
        Break;
      end;
      if wr = wrSignaled then
      begin
{$IFDEF DEBUGOUT}
        OutputDebugString(PChar(FThreadName + ':�����߽��յ�����ҵ��Ҫ�����ź�'));
{$ENDIF}
        FPending := false;
        if (FOwner.Workers - AtomicIncrement(FOwner.FBusyCount) = 0) and
          (FOwner.Workers < FOwner.MaxWorkers) then
          FOwner.NewWorkerNeeded;
        repeat
          SetFlags(WORKER_LOOKUP, true);
          FActiveJob := FOwner.Popup;
          SetFlags(WORKER_LOOKUP, false);
          if FActiveJob <> nil then
          begin
            SetFlags(WORKER_ISBUSY, true);
            FTimeout := 0;
            FLastActiveTime := FActiveJob.PopTime;
            FActiveJob.Worker := Self;
            FActiveJobProc := FActiveJob.WorkerProc;
            // {$IFDEF NEXTGEN} PQJobProc(@FActiveJob.WorkerProc)^
            // {$ELSE} FActiveJob.WorkerProc.Proc {$ENDIF};
            // ΪClear(AObject)׼���жϣ��Ա���FActiveJob�̲߳���ȫ
            FActiveJobData := FActiveJob.Data;
            if FActiveJob.IsSignalWakeup or (not FActiveJob.Runonce) then
              FActiveJobSource := FActiveJob.Source
            else
              FActiveJobSource := nil;
            if FActiveJob.IsGrouped then
              FActiveJobGroup := FActiveJob.Group
            else
              FActiveJobGroup := nil;
            FActiveJobFlags := FActiveJob.Flags;
            if FActiveJob.FirstStartTime = 0 then
              FActiveJob.FirstStartTime := FLastActiveTime;
            FActiveJob.StartTime := FLastActiveTime;
            try
              FFlags := (FFlags or WORKER_EXECUTING) and (not WORKER_LOOKUP);
{$IFDEF DEBUGOUT}
              DebugOut('DLL:WakeMainThread %x', [IntPtr(@WakeMainThread)]);
              if IsLibrary then
              begin
                OutputDebugString(PChar(FThreadName + ':(DLL) ������ִ����ҵ ' +
                  IntToHex(IntPtr(FActiveJob), SizeOf(Pointer) shl 1)))
              end
              else
                OutputDebugString
                  (PChar(FThreadName + ':������ִ����ҵ ' +
                  IntToHex(IntPtr(FActiveJob), SizeOf(Pointer) shl 1)));
{$ENDIF}
              if FActiveJob.InMainThread then
              begin
                TDLLMainThreadSyncHelper.Current.HookMainWakeup;
                AtomicIncrement(FOwner.FMainThreadJobs);
                Queue(Self, FireInMainThread);
                FSyncEvent.WaitFor(INFINITE);
              end
              else
                DoJob(FActiveJob);
            except
              on E: Exception do
                if Assigned(FOwner.FOnError) then
                  FOwner.FOnError(FActiveJob, E, jesExecute);
            end;
            AfterExecute;
          end
          else
            FFlags := FFlags and (not WORKER_LOOKUP);
        until (FActiveJob = nil) or Terminated or FOwner.FTerminating or
          (not FOwner.Enabled);
        SetFlags(WORKER_ISBUSY, false);
        AtomicDecrement(FOwner.FBusyCount);
        // ThreadYield;
      end;
      if (FOwner.FWorkerCount > FOwner.FMaxWorkers) or
        (FTimeout >= FOwner.FireTimeout + FFireDelay) then
      // ��һ������ӳ٣��Ա���ͬʱ�ͷ�
      begin
        FOwner.WorkerTimeout(Self);
        if not IsFiring then
          FTimeout := 0;
      end;
    end;
  except
    on E: Exception do
    begin
      if Assigned(FOwner.FOnError) then
        FOwner.FOnError(FActiveJob, E, jesExecute);
    end;
  end;
  SetFlags(WORKER_RUNNING, false);
{$IFDEF DEBUGOUT}
  OutputDebugString(PChar(FThreadName + ':��������'));
{$ENDIF}
{$IFDEF MSWINDOWS}
  if ComInitialized then
    CoUninitialize;
{$ENDIF}
  FOwner.WorkerTerminate(Self);
{$IFDEF DEBUGOUT}
  OutputDebugString(PChar(IntToStr(ThreadId) + ' -�������˳�'));
{$ENDIF}
end;

procedure TQWorker.FireInMainThread;
begin
  FMainThreadJob := FActiveJob;
  try
    if not(FActiveJob.IsTerminated or FOwner.Terminating) then
      FActiveJob.Worker.DoJob(FActiveJob)
{$IFDEF DEBUGOUT}
    else
      DebugOut('��ҵ�ڵ���ǰ����');
{$ENDIF}
  except
    on E: Exception do
    begin
      if Assigned(FOwner.OnError) then
        FOwner.OnError(FActiveJob, E, jesExecute);
    end;
  end;
  FMainThreadJob := nil;
  FSyncEvent.SetEvent;
  AtomicDecrement(FOwner.FMainThreadJobs);
end;

procedure TQWorker.ForceQuit;
var
  AThread: TThread;
begin
  // ���棺�˺�����ǿ�ƽ�����ǰ�����ߣ���ǰ�����ߵ���ҵʵ���ϱ�ǿ��ֹͣ�����ܻ�����ڴ�й¶
  AThread := Self;
  if ThreadExists(AThread.ThreadId) then
    AThread.Suspended := true;
  AThread.Terminate;
  TThread.Synchronize(nil, DoTerminate);
{$IFDEF MSWINDOWS}
  TerminateThread(Handle, $FFFFFFFF);
{$ENDIF}
  FOwner.WorkerTerminate(Self);
  if Assigned(FActiveJob) then
  begin
    AtomicDecrement(FOwner.FBusyCount);
    if not IsCleaning then
      AfterExecute;
  end;
  if FreeOnTerminate then
    FreeAndNil(AThread);
end;

function TQWorker.GetExtObject: TQWorkerExt;
begin
  if Assigned(FOwner.WorkerExtClass) and (not Assigned(FExtObject)) then
    FExtObject := FOwner.WorkerExtClass.Create(Self);
  Result := FExtObject;
end;

function TQWorker.GetFlags(AIndex: Integer): Boolean;
begin
  Result := ((FFlags and AIndex) <> 0);
end;

function TQWorker.GetIsIdle: Boolean;
begin
  Result := not IsBusy;
end;

procedure TQWorker.SetFlags(AIndex: Integer; AValue: Boolean);
begin
  if AValue then
    FFlags := FFlags or AIndex
  else
    FFlags := FFlags and (not AIndex);
end;

{ TQWorkers }

function TQWorkers.Post(AJob: PQJob): IntPtr;
begin
  Result := 0;
  if (not FTerminating) and (Assigned(AJob.WorkerProc.Proc)
{$IFDEF UNICODE} or Assigned(AJob.WorkerProc.ProcA){$ENDIF}) then
  begin
    if AJob.Runonce and (AJob.FirstDelay = 0) then
    begin
      if FSimpleJobs.Push(AJob) then
      begin
        Result := IntPtr(AJob);
        LookupIdleWorker(true);
      end;
    end
    else if AJob.IsByPlan then
    begin
      if FPlanJobs.Push(AJob) then
        Result := IntPtr(AJob) or JOB_HANDLE_PLAN_MASK;
    end
    else if FRepeatJobs.Push(AJob) then
    begin
      Result := IntPtr(AJob) or JOB_HANDLE_REPEAT_MASK;
      LookupIdleWorker(false);
    end;
  end
  else
  begin
    AJob.Next := nil;
    FreeJob(AJob);
  end;
end;

function TQWorkers.Post(AProc: TQJobProc; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  AInsertToFirst: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, true, ARunInMainThread);
  AJob.AsFirst := AInsertToFirst;
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProc; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  AJob.Interval := AInterval;
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProcG; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  AInsertToFirst: Boolean): IntPtr;
begin
  Result := Post(TQJobProc(MakeJobProc(AProc)), AData, ARunInMainThread,
    AFreeType, AInsertToFirst);
end;

{$IFDEF UNICODE}

function TQWorkers.Post(AProc: TQJobProcA; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  AInsertToFirst: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, true, ARunInMainThread);
  AJob.AsFirst := AInsertToFirst;
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProcA;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean;
  AInsertToFirst: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, true, ARunInMainThread);
  AJob.AsFirst := AInsertToFirst;
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.Clear(AObject: Pointer; AMaxTimes: Integer;
  AWaitRunningDone: Boolean): Integer;
var
  ACleared: Integer;
  AWaitParam: TWorkerWaitParam;
  function ClearSignalJobs: Integer;
  var
    I: Integer;
    AJob, ANext, APrior: PQJob;
    ASignal: PQSignal;
  begin
    Result := 0;
    FLocker.Enter;
    try
      for I := 0 to FMaxSignalId - 1 do
      begin
        ASignal := FSignalJobs[I];
        AJob := ASignal.First;
        APrior := nil;
        while Assigned(AJob) and (AMaxTimes <> 0) do
        begin
          ANext := AJob.Next;
          if IsObjectJob(AJob, AObject) then
          begin
            if ASignal.First = AJob then
              ASignal.First := ANext;
            if Assigned(APrior) then
              APrior.Next := ANext;
            AJob.Next := nil;
            FreeJob(AJob);
            Dec(AMaxTimes);
            Inc(Result);
          end
          else
            APrior := AJob;
          AJob := ANext;
        end;
        if AMaxTimes = 0 then
          Break;
      end;
      Dec(FSignalJobCount);
    finally
      FLocker.Leave;
    end;
  end;

begin
  Result := 0;
  if Self <> nil then
  begin
    ACleared := FSimpleJobs.Clear(AObject, AMaxTimes);
    Inc(Result, ACleared);
    Dec(AMaxTimes, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FRepeatJobs.Clear(AObject, AMaxTimes);
    Inc(Result, ACleared);
    Dec(AMaxTimes, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := ClearSignalJobs;
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FPlanJobs.Clear(AObject, AMaxTimes);
    Inc(Result, ACleared);
    Dec(AMaxTimes, ACleared);
    if AMaxTimes = 0 then
      Exit;
    AWaitParam.WaitType := 0;
    AWaitParam.Bound := AObject;
    WaitRunningDone(AWaitParam, not AWaitRunningDone);
  end;
end;

function TQWorkers.At(AProc: TQJobProc; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  AJob.Interval := AInterval;
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;

function TQWorkers.At(AProc: TQJobProc; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
  ADelay: Int64;
  ANow: TDateTime;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  AJob.Interval := AInterval;
  ANow := Now;
  if Trunc(ATime) = 0 then
    // ���û�д������ڲ��֣��򲻱Ƚ�����
    ANow := ANow - Trunc(ANow);
  // ���ʱ���
  if ANow > ATime then // ʱ���ѹ�
  begin
    if AInterval > 0 then // �ظ���ҵ�������´ε�ִ��ʱ��
    begin
      ADelay := MilliSecondsBetween(ATime, ANow) * 10;
      ADelay := (ADelay div AInterval + 1) * AInterval - ADelay;
    end
    else // ��ҵ�Ѿ�����ִ���ڣ����Ҳ����ظ���ҵ�����Ե�
    begin
      JobPool.Push(AJob);
      Result := 0;
      Exit;
    end;
  end
  else if ANow < ATime then
    ADelay := MilliSecondsBetween(ANow, ATime) * 10
  else
    ADelay := 0;
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;

class function TQWorkers.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProc; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
begin
  Result := TQForJobs.For(AStartIndex, AStopIndex, AWorkerProc, AMsgWait, AData,
    AFreeType);
end;

class function TQWorkers.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcG; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
begin
  Result := TQForJobs.For(AStartIndex, AStopIndex, AWorkerProc, AMsgWait, AData,
    AFreeType);
end;

function TQWorkers.At(AProc: TQJobProc; const ADelay, AInterval: Int64;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := At(AProc, ADelay, AInterval,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), ARunInMainThread,
    jdfFreeAsParams);
end;

function TQWorkers.At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := At(AProc, ADelay, AInterval,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), ARunInMainThread,
    jdfFreeAsParams);
end;

function TQWorkers.At(AProc: TQJobProc; const ATime: TDateTime;
  const AInterval: Int64; const AParams: array of TQJobParamPair;
  ARunInMainThread: Boolean): IntPtr;
begin
  Result := At(AProc, ATime, AInterval,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), ARunInMainThread,
    jdfFreeAsParams);
end;

function TQWorkers.At(AProc: TQJobProcG; const ATime: TDateTime;
  const AInterval: Int64; const AParams: array of TQJobParamPair;
  ARunInMainThread: Boolean): IntPtr;
begin
  Result := At(AProc, ATime, AInterval,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), ARunInMainThread,
    jdfFreeAsParams);
end;
{$IFDEF UNICODE}

class function TQWorkers.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcA; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
begin
  Result := TQForJobs.For(AStartIndex, AStopIndex, AWorkerProc, AMsgWait, AData,
    AFreeType);
end;

function TQWorkers.At(AProc: TQJobProcA; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
  ADelay: Int64;
  ANow, ATemp: TDateTime;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  AJob.Interval := AInterval;
  // ATime����ֻҪʱ�䲿�֣����ں���
  ANow := Now;
  ANow := ANow - Trunc(ANow);
  ATemp := ATime - Trunc(ATime);
  if ANow > ATemp then
    // �ðɣ�����ĵ��Ѿ����ˣ�������
    ADelay := Trunc(((1 + ANow) - ATemp) * Q1Day)
    // �ӳٵ�ʱ�䣬��λΪ0.1ms
  else
    ADelay := Trunc((ATemp - ANow) * Q1Day);
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;

function TQWorkers.At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := At(AProc, ADelay, AInterval,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), ARunInMainThread,
    jdfFreeAsParams);
end;

function TQWorkers.At(AProc: TQJobProcA; const ATime: TDateTime;
  const AInterval: Int64; const AParams: array of TQJobParamPair;
  ARunInMainThread: Boolean): IntPtr;
begin
  Result := At(AProc, ATime, AInterval,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), ARunInMainThread,
    jdfFreeAsParams);
end;
{$ENDIF}

procedure TQWorkers.AfterPlanRun(AJob: PQJob; AUsedTime: Int64);
begin
  AJob := PQJob(AJob.PlanJob);
  AJob.AfterRun(AUsedTime);
  FPlanJobs.FLocker.Enter;
  try
    Dec(AJob.ExtData.AsPlan.Runnings);
  finally
    FPlanJobs.FLocker.Leave;
  end;
end;

function TQWorkers.Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer;
  AWaitRunningDone: Boolean): Integer;
var
  ACleared: Integer;
  AWaitParam: TWorkerWaitParam;
  function ClearSignalJobs: Integer;
  var
    I: Integer;
    AJob, ANext, APrior: PQJob;
    ASignal: PQSignal;
  begin
    Result := 0;
    FLocker.Enter;
    try
      for I := 0 to FMaxSignalId - 1 do
      begin
        ASignal := FSignalJobs[I];
        AJob := ASignal.First;
        APrior := nil;
        while Assigned(AJob) and (AMaxTimes <> 0) do
        begin
          ANext := AJob.Next;
          if SameWorkerProc(AJob.WorkerProc, AProc) and
            ((AData = Pointer(-1)) or (AJob.Data = AData)) then
          begin
            if ASignal.First = AJob then
              ASignal.First := ANext;
            if Assigned(APrior) then
              APrior.Next := ANext;
            AJob.Next := nil;
            FreeJob(AJob);
            Inc(Result);
            Dec(AMaxTimes);
          end
          else
            APrior := AJob;
          AJob := ANext;
        end;
        if AMaxTimes = 0 then
          Break;
      end;
      Dec(FSignalJobCount);
    finally
      FLocker.Leave;
    end;
  end;

begin
  Result := 0;
  if Self <> nil then
  begin
    ACleared := FSimpleJobs.Clear(AProc, AData, AMaxTimes);
    Dec(AMaxTimes, ACleared);
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FRepeatJobs.Clear(AProc, AData, AMaxTimes);
    Dec(AMaxTimes, ACleared);
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := ClearSignalJobs;
    // Don dec AMaxTimes in current line
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FPlanJobs.Clear(AProc, AData, AMaxTimes);
    Dec(AMaxTimes, ACleared);
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    AWaitParam.WaitType := 1;
    AWaitParam.Data := AData;
    AWaitParam.WorkerProc := TMethod(AProc);
    WaitRunningDone(AWaitParam, not AWaitRunningDone);
  end;
{$IFDEF UNICODE}
  if TMethod(AProc).Data = Pointer(-1) then
    TQJobProcA(TMethod(AProc).Code) := nil;
{$ENDIF}
end;

procedure TQWorkers.ClearWorkers;
  function WorkerExists: Boolean;
  var
    J: Integer;
  begin
    Result := false;
    FLocker.Enter;
    try
      J := FWorkerCount - 1;
      while J >= 0 do
      begin
        if ThreadExists(FWorkers[J].ThreadId) then
        begin
          Result := true;
          Break;
        end;
        Dec(J);
      end;
    finally
      FLocker.Leave;
    end;
  end;
  procedure SetEvents;
  var
    I, C: Integer;
  begin
    C := 0;
    FLocker.Enter;
    try
      FRepeatJobs.FFirstFireTime := 0;
      for I := 0 to FWorkerCount - 1 do
      begin
        if ThreadExists(FWorkers[I].ThreadId) then
        // �� DLL �У��߳̿��ܱ� Windows ֱ�ӽ�����
        begin
          FWorkers[I].FEvent.SetEvent;
          Inc(C);
        end;
      end;
    finally
      FLocker.Leave;
      if C = 0 then
        FTerminateEvent.SetEvent;
    end;
  end;

{$IFDEF MSWINDOWS}
  procedure ProcessMainThreadJobs;
  begin
    while FMainThreadJobs > 0 do
    begin
      // ����������߳��У�����ֱ�����д�ͬ������ҵ
      if GetCurrentThreadId = MainThreadId then
        CheckSynchronize
      else if Assigned(WakeMainThread) then
      begin
        WakeMainThread(nil);
        Sleep(10);
      end;
    end;
  end;
{$ENDIF}

begin
  FTerminating := true;
  if not Assigned(FTerminateEvent) then
    FTerminateEvent := TEvent.Create(nil, true, false, '');
  SetEvents;
{$IFDEF MSWINDOWS}
  repeat
    ProcessMainThreadJobs;
  until FTerminateEvent.WaitFor(10) = wrSignaled;
{$ELSE}
  FTerminateEvent.WaitFor(INFINITE);
{$ENDIF}
  FreeAndNil(FTerminateEvent);
  while FWorkerCount > 0 do
    FWorkers[0].ForceQuit;
  {
    AInMainThread := GetCurrentThreadId = MainThreadId;
    while (FWorkerCount > 0) and WorkerExists do
    begin
    SetEvents;
    if AInMainThread then
    ProcessAppMessage
    else
    Sleep(10);
    end;
    for I := 0 to FWorkerCount - 1 do
    begin
    if FWorkers[I] <> nil then
    FreeObject(FWorkers[I]);
    end;
    FWorkerCount := 0;
  }
end;

constructor TQWorkers.Create(AMinWorkers: Integer);
var
  ACpuCount: Integer;
  I: Integer;
begin
  FSimpleJobs := TQSimpleJobs.Create(Self);
  FPlanJobs := TQSimpleJobs.Create(Self);
  FRepeatJobs := TQRepeatJobs.Create(Self);
  SetLength(FSignalJobs, 32); // Ĭ��32��Signal��Ȼ��ɱ���������
  FSignalNameList := TList.Create;
  FFireTimeout := DEFAULT_FIRE_TIMEOUT;
  FJobFrozenTime := INFINITE;
  FStaticThread := TStaticThread.Create;
  ACpuCount := GetCPUCount;
  if AMinWorkers < 1 then
    FMinWorkers := 2
  else
    FMinWorkers := AMinWorkers;
  // ���ٹ�����Ϊ2��
  FMaxWorkers := (ACpuCount shl 1) + 1;
  if FMaxWorkers <= FMinWorkers then
    FMaxWorkers := (FMinWorkers shl 1) + 1;
  FLocker := TCriticalSection.Create;
  FTerminating := false;
  // ����Ĭ�Ϲ�����
  FWorkerCount := 0;
  SetLength(FWorkers, FMaxWorkers + 1);
  for I := 0 to FMinWorkers - 1 do
    FWorkers[I] := CreateWorker(true);
  for I := 0 to FMinWorkers - 1 do
  begin
    FWorkers[I].FEvent.SetEvent;
    FWorkers[I].Suspended := false;
  end;
  FMaxLongtimeWorkers := (FMaxWorkers shr 1);
  FStaticThread.Suspended := false;
  FSignalQueue := TQSignalQueue.Create(Self);
end;

function TQWorkers.CreateWorker(ASuspended: Boolean): TQWorker;
begin
  if FWorkerCount < FMaxWorkers then
  begin
    Result := TQWorker.Create(Self);
    FWorkers[FWorkerCount] := Result;
{$IFDEF MSWINDOWS}
    SetThreadCPU(Result.Handle, FWorkerCount mod GetCPUCount);
{$ELSE}
    SetThreadCPU(Result.ThreadId, FWorkerCount mod GetCPUCount);
{$ENDIF}
    Inc(FWorkerCount);
    if not ASuspended then
    begin
      Result.FPending := true;
      Result.FEvent.SetEvent;
      Result.Suspended := false;
    end;
  end
  else
    Result := nil;
end;

function TQWorkers.Delay(AProc: TQJobProc; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  ARepeat: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, not ARepeat, ARunInMainThread);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  if ADelay > 0 then
    AJob.FirstDelay := ADelay;
  AJob.IsDelayRepeat := ARepeat;
  Result := Post(AJob);
end;

function TQWorkers.Delay(AProc: TQJobProcG; ADelay: Int64;
  const AParams: array of TQJobParamPair;
  ARunInMainThread, ARepeat: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, not ARepeat, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  if ADelay > 0 then
    AJob.FirstDelay := ADelay;
  AJob.IsDelayRepeat := ARepeat;
  Result := Post(AJob);
end;

function TQWorkers.Delay(AProc: TQJobProc; ADelay: Int64;
  const AParams: array of TQJobParamPair;
  ARunInMainThread, ARepeat: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, not ARepeat, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  if ADelay > 0 then
    AJob.FirstDelay := ADelay;
  AJob.IsDelayRepeat := ARepeat;
  Result := Post(AJob);
end;

{$IFDEF UNICODE}

function TQWorkers.Delay(AProc: TQJobProcA; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  ARepeat: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, not ARepeat, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  if ADelay > 0 then
    AJob.FirstDelay := ADelay;
  AJob.IsDelayRepeat := ARepeat;
  Result := Post(AJob);
end;

function TQWorkers.Delay(AProc: TQJobProcA; ADelay: Int64;
  const AParams: array of TQJobParamPair;
  ARunInMainThread, ARepeat: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, not ARepeat, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  if ADelay > 0 then
    AJob.FirstDelay := ADelay;
  AJob.IsDelayRepeat := ARepeat;
  Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.Delay(AProc: TQJobProcG; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  ARepeat: Boolean): IntPtr;
begin
  Result := Delay(TQJobProc(MakeJobProc(AProc)), ADelay, AData,
    ARunInMainThread, AFreeType, ARepeat);
end;

destructor TQWorkers.Destroy;
var
  I: Integer;
begin
  ClearWorkers;
  FLocker.Enter;
  try
    FreeObject(FSimpleJobs);
    FreeObject(FPlanJobs);
    FreeObject(FRepeatJobs);
    for I := 0 to FMaxSignalId - 1 do
    begin
      if Assigned(FSignalJobs[I].First) then
        FreeJob(FSignalJobs[I].First);
      Dispose(FSignalJobs[I]);
    end;
    SetLength(FSignalJobs, 0);
    FreeAndNil(FSignalQueue);
    FreeAndNil(FSignalNameList);
  finally
    FreeObject(FLocker);
  end;

{$IFDEF MSWINDOWS}
  if IsLibrary or ModuleIsLib then
  begin
    TerminateThread(FStaticThread.Handle, 1);
    FreeAndNil(TStaticThread(FStaticThread).FEvent);
    FreeAndNil(FStaticThread);
  end
  else
{$ENDIF}
  begin
    FStaticThread.Terminate;
    while ThreadExists(FStaticThread.ThreadId) do
      Sleep(10);
    FreeAndNil(FStaticThread);
  end;
  inherited;
end;

procedure TQWorkers.DisableWorkers;
begin
  AtomicIncrement(FDisableCount);
end;

procedure TQWorkers.DoCustomFreeData(AFreeType: TQJobDataFreeType;
  const AData: Pointer);
begin
  if Assigned(FOnCustomFreeData) then
    FOnCustomFreeData(Self, AFreeType, AData);
end;

procedure TQWorkers.DoJobFree(ATable: TQHashTable; AHash: Cardinal;
  AData: Pointer);
var
  ASignal: PQSignal;
begin
  ASignal := AData;
  if ASignal.First <> nil then
    FreeJob(ASignal.First);
  Dispose(ASignal);
end;

procedure TQWorkers.DoPlanCheck;
var
  AItem, ATimeoutJob, APrior, ANext, AJob: PQJob;
  ATime: TDateTime;
  ATimestamp: Int64;
  APlan: PQJobPlanData;
  ACheckResult: TQPlanTimeoutCheckResult;
begin
  ATime := Now;
  ATimestamp := GetTimestamp;
  ATimeoutJob := nil;
  APrior := nil;
  FPlanJobs.FLocker.Enter;
  try
    AItem := FPlanJobs.FFirst;
    while Assigned(AItem) do
    begin
      APlan := AItem.ExtData.AsPlan;
      ACheckResult := APlan.Plan.Timeout(ATime);
      case ACheckResult of
        pcrOk, pcrTimeout:
          begin
            APlan.Plan.LastTime := ATime;
            AJob := JobPool.Pop;
            AJob.Assign(AItem);
            AJob.Source := AItem;
            AJob.Data := AItem.ExtData.AsPlan.OriginData;
            AJob.IsByPlan := true;
            AJob.FreeType := AItem.ExtData.AsPlan.DataFreeType;
            AJob.PlanJob := AItem;
            if APlan.Runnings = 0 then
            begin
              AJob.FirstStartTime := ATimestamp;
              APlan.Plan.FirstTime := ATime;
              AItem.FirstStartTime := ATimestamp;
            end
            else
              AJob.FirstStartTime := SecondsBetween(APlan.Plan.FirstTime, ATime)
                * Q1Second;
            AJob.StartTime := ATimestamp;
            AItem.StartTime := ATimestamp;
            AJob.NextTime := AItem.NextTime;
            AItem.PopTime := ATimestamp;
            Inc(APlan.Runnings);
            if not FSimpleJobs.Push(AJob) then
            begin
              JobPool.Push(AJob);
              Break;
            end;
          end;
        pcrExpired:
          begin
            if APlan.Runnings = 0 then
            begin
              ANext := AItem.Next;
              if AItem = FPlanJobs.FFirst then
                FPlanJobs.FFirst := ANext;
              if AItem = FPlanJobs.FLast then
                FPlanJobs.FLast := APrior;
              AItem.Next := ATimeoutJob;
              ATimeoutJob := AItem;
              if Assigned(APrior) then
                APrior.Next := ANext;
              AItem := ANext;
              continue;
            end;
          end;
      end;
      APrior := AItem;
      AItem := AItem.Next;
    end;
  finally
    FPlanJobs.FLocker.Leave;
    if FSimpleJobs.Count > 0 then
      LookupIdleWorker(true);
    if Assigned(ATimeoutJob) then
      FreeJob(ATimeoutJob);
  end;
end;

procedure TQWorkers.EnableWorkers;
var
  ANeedCount: Integer;
begin
  if AtomicDecrement(FDisableCount) = 0 then
  begin
    if (FSimpleJobs.Count > 0) or (FRepeatJobs.Count > 0) then
    begin
      ANeedCount := FSimpleJobs.Count + FRepeatJobs.Count;
      while ANeedCount > 0 do
      begin
        if not LookupIdleWorker(true) then
          Break;
        Dec(ANeedCount);
      end;
    end;
  end;
end;

function TQWorkers.EnumJobStates: TQJobStateArray;
var
  AJob: PQJob;
  I: Integer;
  ARunnings: TQJobStateArray;
  AStampDelta: Int64;
  ATimeDelta: TDateTime;
  procedure EnumSimpleJobs(ASimpleJobs: TQSimpleJobs);
  var
    AFirst: PQJob;
  begin
    I := Length(Result);
    AFirst := ASimpleJobs.PopAll;
    AJob := AFirst;
    SetLength(Result, 4096);
    while AJob <> nil do
    begin
      if I >= Length(Result) then
        SetLength(Result, Length(Result) + 4096);
      Assert(AJob.Handle <> 0);
      Result[I].Handle := AJob.Handle;
      Result[I].Proc := AJob.WorkerProc;
{$IFDEF UNICODE}
      if AJob.IsAnonWorkerProc then
      begin
        Result[I].Proc.ProcA := nil;
        TQJobProcA(Result[I].Proc.ProcA) := TQJobProcA(AJob.WorkerProc.ProcA);
      end;
{$ENDIF}
      Result[I].Flags := AJob.Flags;
      Result[I].PushTime := AJob.PushTime;
      if AJob.IsByPlan then
      begin
        Result[I].Plan := AJob.ExtData.AsPlan.Plan;
        Result[I].Runs := AJob.Runs;
        Result[I].PopTime := AJob.PopTime;
        Result[I].AvgTime := AJob.AvgTime;
        Result[I].TotalTime := AJob.TotalUsedTime;
        Result[I].MaxTime := AJob.MaxUsedTime;
        Result[I].MinTime := AJob.MinUsedTime;
        Result[I].NextTime := AStampDelta + MilliSecondsBetween
          (AJob.ExtData.AsPlan.Plan.NextTime, ATimeDelta) * 10;
      end;
      AJob := AJob.Next;
      Inc(I);
    end;
    ASimpleJobs.Repush(AFirst);
    SetLength(Result, I);
  end;
  procedure EnumRepeatJobs;
  var
    ANode: TQRBNode;
    ATemp: TQJobStateArray;
    L: Integer;
  begin
    I := 0;
    FRepeatJobs.FLocker.Enter;
    try
      ANode := FRepeatJobs.FItems.First;
      if FRepeatJobs.Count < 4 then
        SetLength(ATemp, 4)
      else
        SetLength(ATemp, FRepeatJobs.Count);
      while ANode <> nil do
      begin
        AJob := ANode.Data;
        while Assigned(AJob) do
        begin
          Assert(AJob.Handle <> 0);
          if I = Length(ATemp) then
            SetLength(ATemp, I shl 1);
          ATemp[I].Handle := AJob.Handle;
          ATemp[I].Proc := AJob.WorkerProc;
{$IFDEF UNICODE}
          if AJob.IsAnonWorkerProc then
          begin
            ATemp[I].Proc.ProcA := nil;
            TQJobProcA(ATemp[I].Proc.ProcA) := TQJobProcA(AJob.WorkerProc.ProcA)
          end;
{$ENDIF}
          ATemp[I].Flags := AJob.Flags;
          ATemp[I].Runs := AJob.Runs;
          ATemp[I].PushTime := AJob.PushTime;
          ATemp[I].PopTime := AJob.PopTime;
          ATemp[I].AvgTime := AJob.AvgTime;
          ATemp[I].TotalTime := AJob.TotalUsedTime;
          ATemp[I].MaxTime := AJob.MaxUsedTime;
          ATemp[I].MinTime := AJob.MinUsedTime;
          ATemp[I].NextTime := AJob.NextTime;
          AJob := AJob.Next;
          Inc(I);
        end;
        ANode := ANode.Next;
      end;
      SetLength(ATemp, I);
    finally
      FRepeatJobs.FLocker.Leave;
    end;
    if I > 0 then
    begin
      L := Length(Result);
      SetLength(Result, Length(Result) + I);
      Move(ATemp[0], Result[L], I * SizeOf(TQJobState));
    end;
  end;
  procedure EnumSignalJobs;
  var
    ATemp: TQJobStateArray;
    ASignal: PQSignal;
    L: Integer;
  begin
    L := 0;
    I := 0;
    FLocker.Enter;
    try
      SetLength(ATemp, 4096);
      while I < FMaxSignalId do
      begin
        ASignal := FSignalJobs[I];
        AJob := ASignal.First;
        while Assigned(AJob) do
        begin
          if L >= Length(ATemp) then
            SetLength(ATemp, Length(ATemp) + 4096);
          ATemp[L].Handle := AJob.Handle;
          ATemp[L].Proc := AJob.WorkerProc;
{$IFDEF UNICODE}
          if AJob.IsAnonWorkerProc then
          begin
            ATemp[I].Proc.ProcA := nil;
            TQJobProcA(ATemp[I].Proc.ProcA) := TQJobProcA(AJob.WorkerProc.ProcA)
          end;
{$ENDIF}
          ATemp[L].Runs := AJob.Runs;
          ATemp[L].Flags := AJob.Flags;
          ATemp[L].PushTime := AJob.PushTime;
          ATemp[L].PopTime := AJob.PopTime;
          ATemp[L].AvgTime := AJob.AvgTime;
          ATemp[L].TotalTime := AJob.TotalUsedTime;
          ATemp[L].MaxTime := AJob.MaxUsedTime;
          ATemp[L].MinTime := AJob.MinUsedTime;
          AJob := AJob.Next;
          Inc(L);
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
    end;
    if L > 0 then
    begin
      I := Length(Result);
      SetLength(Result, Length(Result) + L);
      Move(ATemp[0], Result[I], L * SizeOf(TQJobState));
    end;
  end;
  procedure CheckRunnings;
  var
    C: Integer;
    J: Integer;
    AFound: Boolean;
  begin
    DisableWorkers;
    C := 0;
    FLocker.Enter;
    try
      SetLength(ARunnings, FWorkerCount);
      I := 0;
      while I < FWorkerCount do
      begin
        if FWorkers[I].IsExecuting then
        begin
          ARunnings[C].Handle := FWorkers[I].FActiveJob.Handle;
          ARunnings[C].Proc := FWorkers[I].FActiveJobProc;
          ARunnings[C].Flags := FWorkers[I].FActiveJobFlags;
          ARunnings[C].IsRunning := true;
          ARunnings[C].EscapedTime := GetTimestamp - FWorkers[I]
            .FLastActiveTime;
          ARunnings[C].PopTime := FWorkers[I].FLastActiveTime;
          Inc(C);
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
      EnableWorkers;
    end;
    SetLength(ARunnings, C);
    I := 0;
    while I < C do
    begin
      AFound := false;
      for J := 0 to High(Result) do
      begin
        if ARunnings[I].Handle = Result[J].Handle then
        begin
          AFound := true;
          Break;
        end;
      end;
      if not AFound then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1] := ARunnings[I];
      end;
      Inc(I);
    end;
  end;

  function IsRunning(AHandle: IntPtr): Boolean;
  var
    J: Integer;
  begin
    AHandle := AHandle and (not $03);
    Result := false;
    for J := 0 to High(ARunnings) do
    begin
      if AHandle = (ARunnings[J].Handle and (not $03)) then
      begin
        Result := true;
        Break;
      end;
    end;
  end;

begin
  ATimeDelta := Now;
  AStampDelta := GetTimestamp;
  SetLength(Result, 0);
  EnumSimpleJobs(FSimpleJobs);
  EnumSimpleJobs(FPlanJobs);
  EnumRepeatJobs;
  EnumSignalJobs;
  CheckRunnings;
  for I := 0 to High(Result) do
    Result[I].IsRunning := IsRunning(Result[I].Handle);
end;

function TQWorkers.EnumWorkerStatus: TQWorkerStatus;
var
  I: Integer;
  function GetMethodName(AMethod: TMethod): QStringW;
  var
    AObjName, AMethodName: QStringW;
{$IFDEF USE_MAP_SYMBOLS}
    ALoc: TQSymbolLocation;
{$ENDIF}
  begin
    if AMethod.Data <> nil then
    begin
      try
        AObjName := TObject(TObject(AMethod.Data)).ClassName;
{$IFDEF USE_MAP_SYMBOLS}
        if LocateSymbol(AMethod.Code, ALoc) then
        begin
          Result := ALoc.FunctionName;
          Exit;
        end
        else
          AMethodName := TObject(AMethod.Data).MethodName(AMethod.Code);
{$ELSE}
        AMethodName := TObject(AMethod.Data).MethodName(AMethod.Code);
{$ENDIF}
      except
        AObjName := IntToHex(NativeInt(AMethod.Data), SizeOf(Pointer) shl 1);
      end;
      if Length(AObjName) = 0 then
        AObjName := IntToHex(NativeInt(AMethod.Data), SizeOf(Pointer) shl 1);
      if Length(AMethodName) = 0 then
        AMethodName := IntToHex(NativeInt(AMethod.Code), SizeOf(Pointer) shl 1);
      Result := AObjName + '::' + AMethodName;
    end
    else if AMethod.Data <> nil then
      Result := IntToHex(NativeInt(AMethod.Code), SizeOf(Pointer) shl 1)
    else
      SetLength(Result, 0);
  end;

begin
  DisableWorkers;
  FLocker.Enter;
  try
    SetLength(Result, Workers);
    for I := 0 to Workers - 1 do
    begin
      Result[I].Processed := FWorkers[I].FProcessed;
      Result[I].ThreadId := FWorkers[I].ThreadId;
      Result[I].IsIdle := FWorkers[I].IsIdle;
      Result[I].LastActive := FWorkers[I].FLastActiveTime;
      Result[I].Timeout := FWorkers[I].FTimeout;
      if not Result[I].IsIdle then
      begin
        Result[I].ActiveJob :=
          GetMethodName(TMethod(FWorkers[I].FActiveJobProc));
        if Assigned(GetThreadStackInfo) then
          Result[I].Stacks := GetThreadStackInfo(FWorkers[I]);
      end;
    end;
  finally
    FLocker.Leave;
    EnableWorkers;
  end;
end;

function CompareName(S1, S2: QStringW): Integer; inline;
begin
  Result := {$IFDEF UNICODE}CompareStr(S1, S2){$ELSE}
    WideCompareStr(S1, S2){$ENDIF};
end;

function DoSignalNameCompare(P1, P2: Pointer): Integer;
begin
  Result := CompareName(PQSignal(P1).Name, PQSignal(P2).Name);
end;

function TQWorkers.FindSignal(const AName: QStringW;
  var AIndex: Integer): Boolean;
var
  L, H, I, C: Integer;
  ASignal: PQSignal;
begin
  L := 0;
  H := FSignalNameList.Count - 1;
  Result := false;
  while L <= H do
  begin
    I := (L + H) shr 1;
    ASignal := FSignalNameList[I];
    C := CompareName(ASignal.Name, AName);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := true;
        L := I;
        Break;
      end;
    end;
  end;
  AIndex := L;
end;

procedure TQWorkers.FireSignalJob(AData: PQSignalQueueItem);
var
  AJob, ACopy: PQJob;
  ASignal: PQSignal;
  AFireCount: Integer;
begin
  AData.FireCount := 0;
  AFireCount := 0;
  AtomicIncrement(AData.RefCount);
  FLocker.Enter;
  if (AData.Id >= 1) and (AData.Id <= FMaxSignalId) then
  begin
    ASignal := FSignalJobs[AData.Id - 1];
    Inc(ASignal.Fired);
    AJob := ASignal.First;
    while AJob <> nil do
    begin
      ACopy := JobPool.Pop;
      ACopy.Assign(AJob);
      JobInitialize(ACopy, AData.Data, jdfFreeByUser, true, AJob.InMainThread);
      ACopy.SignalData := AData;
      AtomicIncrement(AData.FireCount);
      Inc(AFireCount);
      ACopy.Source := AJob;
      if not FSimpleJobs.Push(ACopy) then
        Break;
      AJob := AJob.Next;
    end;
  end;
  FLocker.Leave;
  if AFireCount = 0 then
    SignalQueue.SingalJobDone(AData)
  else
    LookupIdleWorker(false);
end;

procedure TQWorkers.FreeJob(AJob: PQJob);
var
  ANext: PQJob;
  AFreeData: Boolean;
begin
  AFreeData := false;
  CheckWaitChain(AJob);
  while AJob <> nil do
  begin
    ANext := AJob.Next;
    if AJob.PopTime = 0 then
    begin
      if Assigned(FBeforeCancel) then
      begin
        try
          FBeforeCancel(AJob);
        except

        end;
      end;
    end;
    if AJob.IsSignalWakeup and Assigned(AJob.SignalData) then
    begin
      if AtomicDecrement(PQSignalQueueItem(AJob.SignalData).FireCount) = 0 then
        SignalQueue.SingalJobDone(AJob.SignalData);
    end
    else
      AFreeData := AJob.IsDataOwner;
    if (AJob.Data <> nil) and AFreeData then
      FreeJobData(AJob.Data, AJob.FreeType);
    JobPool.Push(AJob);
    AJob := ANext;
  end;
end;

procedure TQWorkers.FreeJobData(AData: Pointer; AFreeType: TQJobDataFreeType);
  procedure DoObjectFree(AObject: TObject);
  var
    AProc: TObjectFreeProc;
    AIndex: Integer;
  begin
    AProc := FindClassFreeProc(AObject.ClassType.ClassInfo, AIndex);
    if Assigned(AProc) then
      AProc(AObject)
    else
      FreeObject(AObject);
  end;

begin
  if AData <> nil then
  begin
    try
      case AFreeType of
        jdfFreeAsObject:
          FreeObject(TObject(AData));
        jdfFreeAsSimpleRecord:
          Dispose(AData);
        jdfFreeAsInterface:
          (IInterface(AData) as IInterface)._Release;
        jdfFreeAsParams:
          IQJobNamedParams(AData)._Release;
      else
        DoCustomFreeData(AFreeType, AData);
      end;
    except
      on E: Exception do
        if Assigned(FOnError) then
          FOnError(nil, E, jesFreeData);
    end;
  end;
end;

function TQWorkers.GetBusyCount: Integer;
begin
  Result := FBusyCount;
end;

function TQWorkers.GetEnabled: Boolean;
begin
  Result := (FDisableCount = 0);
end;

function TQWorkers.GetIdleWorkers: Integer;
begin
  Result := FWorkerCount - BusyWorkers;
end;

function TQWorkers.GetNextRepeatJobTime: Int64;
begin
  Result := FRepeatJobs.FFirstFireTime;
end;

function TQWorkers.GetOutWorkers: Boolean;
begin
  Result := (FBusyCount = MaxWorkers);
end;

function TQWorkers.GetTerminating: Boolean;
begin
  Result := FTerminating or AppTerminated;
end;

function TQWorkers.HandleToJob(const AHandle: IntPtr): PQJob;
begin
  Result := PQJob(AHandle and (not IntPtr(3)));
end;

function TQWorkers.LongtimeJob(AProc: TQJobProc; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  if AtomicIncrement(FLongTimeWorkers) <= FMaxLongtimeWorkers then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, AData, AFreeType, true, false);
    AJob.SetFlags(JOB_LONGTIME, true);
{$IFDEF NEXTGEN}
    PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
    AJob.WorkerProc.Proc := AProc;
{$ENDIF}
    Result := Post(AJob);
  end
  else
  begin
    AtomicDecrement(FLongTimeWorkers);
    Result := 0;
  end;
end;
{$IFDEF UNICODE}

function TQWorkers.LongtimeJob(AProc: TQJobProcA; AData: Pointer;
  AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr;
var
  AJob: PQJob;
begin
  if AtomicIncrement(FLongTimeWorkers) <= FMaxLongtimeWorkers then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, AData, AFreeType, true, false);
    AJob.SetFlags(JOB_LONGTIME, true);
    AJob.WorkerProc.Method := MakeJobProc(AProc);
    Result := Post(AJob);
  end
  else
  begin
    AtomicDecrement(FLongTimeWorkers);
    Result := 0;
  end;
end;
{$ENDIF}

function TQWorkers.LongtimeJob(AProc: TQJobProcG; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := LongtimeJob(TQJobProc(MakeJobProc(AProc)), AData, AFreeType);
end;

function TQWorkers.LookupIdleWorker(AFromStatic: Boolean): Boolean;
var
  AWorker: TQWorker;
  I: Integer;
  APendingCount, APasscount: Integer;
  procedure InternalLookupWorker;
  begin
    FLocker.Enter;
    try
      I := 0;
      while I < FWorkerCount do
      begin
        if (FWorkers[I].IsIdle) and (FWorkers[I].IsRunning) and
          (not FWorkers[I].IsFiring) then
        begin
          if AWorker = nil then
          begin
            if not FWorkers[I].FPending then
            begin
              AWorker := FWorkers[I];
              AWorker.FPending := true;
              AWorker.FEvent.SetEvent;
              Break;
            end
            else
              Inc(APendingCount);
          end;
        end;
        Inc(I);
      end;
      if FWorkerCount = MaxWorkers then
        // ����Ѿ���������ߣ��Ͳ���������
        APasscount := -1
      else if (AWorker = nil) and (APendingCount = 0) then
      // δ�ҵ���û�������еĹ����ߣ����Դ����µ�
      begin
        // OutputDebugString(PChar(Format('Pending %d,Passcount %d',
        // [APendingCount, APasscount])));
        AWorker := CreateWorker(false);
      end;
    finally
      FLocker.Leave;
    end;
  end;

begin
  Result := false;
  if FBusyCount >= FMaxWorkers then
    Exit
  else if (FDisableCount <> 0) or FTerminating then
    Exit;
  AWorker := nil;
  APasscount := 0;
  repeat
    APendingCount := 0;
    // ��������ڽ�͵Ĺ����ߣ���ô�ȴ����
    while FFiringWorkerCount > 0 do
      ThreadYield;
    InternalLookupWorker;
    if (AWorker = nil) and (APendingCount > 0) then
    begin
      // ���û�ܷ��乤���߲�����δ������ɵĹ����ߣ����л����̵߳�ʱ��Ƭ��Ȼ���ٳ��Լ��
      ThreadYield;
      Inc(APasscount);
    end;
  until (APasscount < 0) or (AWorker <> nil);
  Result := AWorker <> nil;
end;

function TQWorkers.NameOfSignal(const AId: Integer): QStringW;
begin
  Result := '';
  FLocker.Enter;
  try
    if (AId > 0) and (AId <= Length(FSignalJobs)) then
      Result := FSignalJobs[AId - 1].Name;
  finally
    FLocker.Leave;
  end;
end;

procedure TQWorkers.NewWorkerNeeded;
begin
  TStaticThread(FStaticThread).CheckNeeded;
end;

function TQWorkers.PeekJobState(AHandle: IntPtr;
  var AResult: TQJobState): Boolean;
var
  AJob: PQJob;
  AJobHandle: IntPtr;
  ARunnings: array of IntPtr;
  procedure PeekSimpleJob(ASimpleJobs: TQSimpleJobs);
  var
    AFirst: PQJob;
  begin
    AFirst := ASimpleJobs.PopAll;
    AJob := AFirst;
    while AJob <> nil do
    begin
      if IntPtr(AJob) = AJobHandle then
      begin
        AResult.Handle := IntPtr(AJob);
        AResult.Proc := AJob.WorkerProc;
{$IFDEF UNICODE}
        if AJob.IsAnonWorkerProc then
        begin
          AResult.Proc.ProcA := nil;
          TQJobProcA(AResult.Proc.ProcA) := TQJobProcA(AJob.WorkerProc.ProcA)
        end;
{$ENDIF}
        AResult.Flags := AJob.Flags;
        AResult.PushTime := AJob.PushTime;
        if AJob.IsByPlan then
        begin
          AResult.Runs := AJob.Runs;
          AResult.PushTime := AJob.PushTime;
          AResult.PopTime := AJob.PopTime;
          AResult.AvgTime := AJob.AvgTime;
          AResult.TotalTime := AJob.TotalUsedTime;
          AResult.MaxTime := AJob.MaxUsedTime;
          AResult.MinTime := AJob.MinUsedTime;
          AResult.NextTime := GetTimestamp + MilliSecondsBetween
            (AJob.ExtData.AsPlan.Plan.NextTime, Now) * 10;
        end;
        Result := true;
        Break;
      end;
      AJob := AJob.Next;
    end;
    ASimpleJobs.Repush(AFirst);
  end;
  procedure PeekRepeatJob;
  var
    ANode: TQRBNode;
  begin
    AHandle := AHandle and (not $03);
    FRepeatJobs.FLocker.Enter;
    try
      ANode := FRepeatJobs.FItems.First;
      while ANode <> nil do
      begin
        AJob := ANode.Data;
        while Assigned(AJob) do
        begin
          if IntPtr(AJob) = AJobHandle then
          begin
            AResult.Handle := IntPtr(AJob) or $01;
            AResult.Proc := AJob.WorkerProc;
{$IFDEF UNICODE}
            if AJob.IsAnonWorkerProc then
            begin
              AResult.Proc.ProcA := nil;
              TQJobProcA(AResult.Proc.ProcA) :=
                TQJobProcA(AJob.WorkerProc.ProcA)
            end;
{$ENDIF}
            AResult.Flags := AJob.Flags;
            AResult.Runs := AJob.Runs;
            AResult.PushTime := AJob.PushTime;
            AResult.PopTime := AJob.PopTime;
            AResult.AvgTime := AJob.AvgTime;
            AResult.TotalTime := AJob.TotalUsedTime;
            AResult.MaxTime := AJob.MaxUsedTime;
            AResult.MinTime := AJob.MinUsedTime;
            AResult.NextTime := AJob.NextTime;
            Result := true;
            Exit;
          end;
          AJob := AJob.Next;
        end;
        ANode := ANode.Next;
      end;
    finally
      FRepeatJobs.FLocker.Leave;
    end;
  end;
  procedure PeekSignalJob;
  var
    ATemp: TQJobStateArray;
    ASignal: PQSignal;
    I: Integer;
  begin
    I := 0;
    AHandle := AHandle and (not $03);
    FLocker.Enter;
    try
      SetLength(ATemp, 4096);
      while I < FMaxSignalId do
      begin
        ASignal := FSignalJobs[I];

        AJob := ASignal.First;
        while Assigned(AJob) do
        begin
          if IntPtr(AJob) = AJobHandle then
          begin
            AResult.Handle := AJob.Handle;
            AResult.Proc := AJob.WorkerProc;
{$IFDEF UNICODE}
            if AJob.IsAnonWorkerProc then
            begin
              AResult.Proc.ProcA := nil;
              TQJobProcA(AResult.Proc.ProcA) :=
                TQJobProcA(AJob.WorkerProc.ProcA);
            end;
{$ENDIF}
            AResult.Runs := AJob.Runs;
            AResult.Flags := AJob.Flags;
            AResult.PushTime := AJob.PushTime;
            AResult.PopTime := AJob.PopTime;
            AResult.AvgTime := AJob.AvgTime;
            AResult.TotalTime := AJob.TotalUsedTime;
            AResult.MaxTime := AJob.MaxUsedTime;
            AResult.MinTime := AJob.MinUsedTime;
            AResult.NextTime := AJob.NextTime;
            Result := true;
            Exit;
          end;
          AJob := AJob.Next;
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
    end;
  end;
  procedure CheckRunnings;
  var
    I: Integer;
  begin
    DisableWorkers;
    FLocker.Enter;
    try
      SetLength(ARunnings, FWorkerCount);
      I := 0;
      while I < FWorkerCount do
      begin
        if FWorkers[I].IsExecuting then
        begin
          AJob := FWorkers[I].FActiveJob;
          if IntPtr(AJob) = AJobHandle then
          begin
            if not Result then
            begin
              AResult.Handle := AHandle;
              AResult.Proc := AJob.WorkerProc;
{$IFDEF UNICODE}
              if AJob.IsAnonWorkerProc then
              begin
                AResult.Proc.ProcA := nil;
                TQJobProcA(AResult.Proc.ProcA) :=
                  TQJobProcA(AJob.WorkerProc.ProcA)
              end;
{$ENDIF}
              AResult.Runs := AJob.Runs;
              AResult.Flags := AJob.Flags;
              AResult.PushTime := AJob.PushTime;
              AResult.PopTime := AJob.PopTime;
              AResult.AvgTime := AJob.AvgTime;
              AResult.TotalTime := AJob.TotalUsedTime;
              AResult.MaxTime := AJob.MaxUsedTime;
              AResult.MinTime := AJob.MinUsedTime;
              AResult.NextTime := AJob.NextTime;
            end;
            AResult.IsRunning := true;
            Result := true;
            Exit;
          end;
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
      EnableWorkers;
    end;
  end;

  function JobType: Integer;
  begin
    Result := AHandle and $03;
    AJobHandle := AHandle - Result;
  end;

begin
  Result := false;
  case JobType of
    0:
      PeekSimpleJob(FSimpleJobs);
    1:
      PeekRepeatJob;
    2:
      PeekSignalJob;
    3:
      PeekSimpleJob(FPlanJobs);
  end;
  CheckRunnings;
end;

function TQWorkers.PeekJobStatics: TQJobStatics;

  function CalcSignalJobs: Integer;
  var
    ASignal: PQSignal;
    AJob: PQJob;
    I: Integer;
  begin
    Result := 0;
    I := 0;
    FLocker.Enter;
    try
      while I < FMaxSignalId do
      begin
        ASignal := FSignalJobs[I];
        AJob := ASignal.First;
        while Assigned(AJob) do
        begin
          AJob := AJob.Next;
          Inc(Result);
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
    end;
  end;

begin
  FillChar(Result, SizeOf(Result), 0);
  Result.Running := FBusyCount;
  Result.Pending := FSimpleJobs.Count + FRepeatJobs.Count + FPlanJobs.Count +
    FSignalJobCount;
  Result.Total := Result.Running + Result.Pending;
end;

function TQWorkers.Plan(AProc: TQJobProcG; const APlan: QStringW;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(AProc, TQPlanMask.Create(APlan), AData, ARunInMainThread,
    AFreeType);
end;

function TQWorkers.Plan(AProc: TQJobProcG; const APlan: TQPlanMask;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(TQJobProc(MakeJobProc(AProc)), APlan, AData, ARunInMainThread,
    AFreeType);
end;

function TQWorkers.Plan(AProc: TQJobProc; const APlan: TQPlanMask;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, TQJobExtData.Create(APlan, AData, AFreeType),
    jdfFreeAsObject, false, ARunInMainThread);
  AJob.IsByPlan := true;
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := Post(AJob);
end;

function TQWorkers.Plan(AProc: TQJobProc; const APlan: QStringW; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(AProc, TQPlanMask.Create(APlan), AData, ARunInMainThread,
    AFreeType);
end;

function TQWorkers.Plan(AProc: TQJobProc; const APlan: QStringW;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Plan(AProc, APlan, Pointer(TQJobParams.Create(AParams)
    as IQJobNamedParams), ARunInMainThread, jdfFreeAsParams);
end;

function TQWorkers.Plan(AProc: TQJobProcG; const APlan: TQPlanMask;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Plan(AProc, APlan, Pointer(TQJobParams.Create(AParams)
    as IQJobNamedParams), ARunInMainThread, jdfFreeAsParams);
end;

function TQWorkers.Plan(AProc: TQJobProc; const APlan: TQPlanMask;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Plan(AProc, APlan, Pointer(TQJobParams.Create(AParams)
    as IQJobNamedParams), ARunInMainThread, jdfFreeAsParams);
end;

function TQWorkers.Plan(AProc: TQJobProcG; const APlan: QStringW;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Plan(AProc, APlan, Pointer(TQJobParams.Create(AParams)
    as IQJobNamedParams), ARunInMainThread, jdfFreeAsParams);
end;

{$IFDEF UNICODE}

function TQWorkers.Plan(AProc: TQJobProcA; const APlan: TQPlanMask;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, TQJobExtData.Create(APlan, AData, AFreeType),
    jdfFreeAsObject, false, ARunInMainThread);
  AJob.IsByPlan := true;
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  Result := Post(AJob);
end;

function TQWorkers.Plan(AProc: TQJobProcA; const APlan: QStringW;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(AProc, TQPlanMask.Create(APlan), AData, ARunInMainThread,
    AFreeType);
end;

function TQWorkers.Plan(AProc: TQJobProcA; const APlan: QStringW;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Plan(AProc, APlan, Pointer(TQJobParams.Create(AParams)
    as IQJobNamedParams), ARunInMainThread, jdfFreeAsParams);
end;

function TQWorkers.Plan(AProc: TQJobProcA; const APlan: TQPlanMask;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Plan(AProc, APlan, Pointer(TQJobParams.Create(AParams)
    as IQJobNamedParams), ARunInMainThread, jdfFreeAsParams);
end;

{$ENDIF}

function TQWorkers.Popup: PQJob;
begin
  Result := FSimpleJobs.Pop;
  if Result = nil then
    Result := FRepeatJobs.Pop;
  if Assigned(Result) and Assigned(FBeforeExecute) then
    FBeforeExecute(Result);
end;

function TQWorkers.RegisterSignal(const AName: QStringW): Integer;
var
  ASignal: PQSignal;
  AIdx: Integer;
begin
  FLocker.Enter;
  try
    if FindSignal(AName, AIdx) then
      Result := PQSignal(FSignalNameList[AIdx]).Id
    else
    begin
      if Length(FSignalJobs) = FMaxSignalId then
        SetLength(FSignalJobs, FMaxSignalId shl 1);
      New(ASignal);
      FSignalJobs[FMaxSignalId] := ASignal;
      Inc(FMaxSignalId);
      ASignal.Id := FMaxSignalId;
      ASignal.Fired := 0;
      ASignal.Name := AName;
      ASignal.First := nil;
      Result := ASignal.Id;
      FSignalNameList.Insert(AIdx, ASignal);
      // OutputDebugString(PWideChar('Signal '+IntToStr(ASignal.Id)+' Allocate '+IntToHex(NativeInt(ASignal),8)));
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQWorkers.SendSignal(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType; AWaitTimeout: Cardinal): TWaitResult;
begin
  Result := SignalQueue.Send(AId, AData, AFreeType, AWaitTimeout);
end;

function TQWorkers.SendSignal(const AName: QStringW; AData: Pointer;
  AFreeType: TQJobDataFreeType; AWaitTimeout: Cardinal): TWaitResult;
begin
  Result := SignalQueue.Send(AName, AData, AFreeType, AWaitTimeout);
end;

procedure TQWorkers.SetEnabled(const Value: Boolean);
begin
  if Value then
    EnableWorkers
  else
    DisableWorkers;
end;

procedure TQWorkers.SetFireTimeout(const Value: Cardinal);
begin
  if Value = 0 then
    FFireTimeout := MaxInt
  else
    FFireTimeout := Value;
end;

procedure TQWorkers.SetMaxLongtimeWorkers(const Value: Integer);
begin
  if FMaxLongtimeWorkers <> Value then
  begin
    if Value > (MaxWorkers shr 1) then
      raise Exception.Create(STooManyLongtimeWorker);
    FMaxLongtimeWorkers := Value;
  end;
end;

procedure TQWorkers.SetMaxWorkers(Value: Integer);
var
  AMaxLong: Integer;
begin
  if Value < FMinWorkers then
    raise Exception.Create(SMaxMinWorkersError);
  if (Value >= 2) and (FMaxWorkers <> Value) then
  begin
    // ǿ����0����ֹ������ĳ�ʱ����ҵ������¼ԭʼ��MaxLongtimeWorkers��ֵ
    AtomicExchange(FMaxLongtimeWorkers, 0);
    // �µ������������������
    AMaxLong := Value shr 1;
    FLocker.Enter;
    try
      if Value < FMinWorkers then
        FMinWorkers := Value;
      // ������ڽ����еĳ�ʱ�乤��������������Value/2����Value����Ϊ FLongTimeWorkers*2���Ա�֤�ܹ�������Ӧ
      if FLongTimeWorkers > AMaxLong then
      begin
        Value := FLongTimeWorkers shl 1;
        AMaxLong := FLongTimeWorkers;
      end;
      if FMaxWorkers < Value then
      begin
        FMaxWorkers := Value;
        SetLength(FWorkers, Value + 1);
      end
      else // FWorkers����ֻ������
        FMaxWorkers := Value;
    finally
      FLocker.Leave;
      AtomicExchange(FMaxLongtimeWorkers, AMaxLong);
    end;
  end;
end;

procedure TQWorkers.SetMinWorkers(const Value: Integer);
begin
  if FMinWorkers <> Value then
  begin
    if (Value < 1) then
      raise Exception.Create(STooFewWorkers)
    else if Value > FMaxWorkers then
      raise Exception.Create(SMaxMinWorkersError);
    FMinWorkers := Value;
  end;
end;

function TQWorkers.Signal(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType; AWaitTimeout: Cardinal): TWaitResult;
begin
  Result := SignalQueue.Send(AId, AData, AFreeType, AWaitTimeout);
end;

function TQWorkers.Signal(const AName: QStringW; AData: Pointer;
  AFreeType: TQJobDataFreeType; AWaitTimeout: Cardinal): TWaitResult;
begin
  Result := SignalQueue.Send(AName, AData, AFreeType, AWaitTimeout);
end;

function TQWorkers.Signal(AId: Integer; const AParams: array of TQJobParamPair;
  AWaitTimeout: Cardinal): TWaitResult;
begin
  Result := SignalQueue.Send(AId,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams,
    AWaitTimeout);
end;

procedure TQWorkers.SignalWorkDone(AJob: PQJob; AUsedTime: Int64);
var
  ASignal: PQSignal;
  ATemp, APrior: PQJob;
begin
  FLocker.Enter;
  try
    ASignal := FSignalJobs[PQSignalQueueItem(AJob.SignalData).Id - 1];
    ATemp := ASignal.First;
    APrior := nil;
    while ATemp <> nil do
    begin
      if ATemp = AJob.Source then
      begin
        if AJob.IsTerminated then
        begin
          if APrior <> nil then
            APrior.Next := ATemp.Next
          else
            ASignal.First := ATemp.Next;
          ATemp.Next := nil;
          FreeJob(ATemp);
        end
        else
        begin
          // �����ź���ҵ��ͳ����Ϣ
          Inc(ATemp.Runs);
          if AUsedTime > 0 then
          begin
            if ATemp.MinUsedTime = 0 then
              ATemp.MinUsedTime := AUsedTime
            else if AUsedTime < ATemp.MinUsedTime then
              ATemp.MinUsedTime := AUsedTime;
            if ATemp.MaxUsedTime = 0 then
              ATemp.MaxUsedTime := AUsedTime
            else if AUsedTime > ATemp.MaxUsedTime then
              ATemp.MaxUsedTime := AUsedTime;
            Break;
          end;
        end;
      end;
      APrior := ATemp;
      ATemp := ATemp.Next;
    end;
  finally
    FLocker.Leave;
  end;
end;

procedure TQWorkers.ValidWorkers;
{$IFDEF VALID_WORKERS}
var
  I: Integer;
{$ENDIF}
begin
{$IFDEF VALID_WORKERS}
  for I := 0 to FWorkerCount - 1 do
  begin
    if FWorkers[I] = nil then
      OutputDebugString('Workers array bad')
    else if FWorkers[I].FIndex <> I then
      OutputDebugString('Workers index bad');
  end;
{$ENDIF}
end;

procedure TQWorkers.WorkerTimeout(AWorker: TQWorker);
var
  AWorkers: Integer;
begin
  AWorkers := FWorkerCount - AtomicIncrement(FFiringWorkerCount);
  if (AWorkers < FMinWorkers) or (AWorkers = BusyWorkers) then
    // ������1������
    AtomicDecrement(FFiringWorkerCount)
  else
  begin
    AWorker.SetFlags(WORKER_FIRING, true);
    AWorker.Terminate;
  end;
end;

procedure TQWorkers.WorkerTerminate(AWorker: TQWorker);
var
  I, J: Integer;
begin
  FLocker.Enter;
  try
    Dec(FWorkerCount);
    if AWorker.IsFiring then
      AtomicDecrement(FFiringWorkerCount);
    // ����ǵ�ǰæµ�Ĺ����߱����
    if FWorkerCount = 0 then
    begin
      FWorkers[0] := nil;
      if Assigned(FTerminateEvent) then
        FTerminateEvent.SetEvent;
    end
    else
    begin
      for I := 0 to FWorkerCount do
      begin
        if AWorker = FWorkers[I] then
        begin
          for J := I to FWorkerCount do
            FWorkers[J] := FWorkers[J + 1];
          Break;
        end;
      end;
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQWorkers.Wait(AProc: TQJobProc; ASignalId: Integer;
  ARunInMainThread: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
  ASignal: PQSignal;
begin
  if (not FTerminating) and Assigned(AProc) then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, AData, AFreeType, false, ARunInMainThread);
{$IFDEF NEXTGEN}
    PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
    AJob.WorkerProc.Proc := AProc;
{$ENDIF}
    // Assert(AJob.WorkerProc.Code<>nil);
    AJob.SetFlags(JOB_SIGNAL_WAKEUP, true);
    AJob.PushTime := GetTimestamp;
    Result := 0;
    FLocker.Enter;
    try
      if (ASignalId >= 1) and (ASignalId <= FMaxSignalId) then
      begin
        ASignal := FSignalJobs[ASignalId - 1];
        AJob.Next := ASignal.First;
        ASignal.First := AJob;
        Result := AJob.Handle;
        Inc(FSignalJobCount);
      end;
    finally
      FLocker.Leave;
      if Result = 0 then
        JobPool.Push(AJob);
    end;
  end
  else
    Result := 0;
end;

function TQWorkers.Wait(AProc: TQJobProc; const ASignalName: QStringW;
  ARunInMainThread: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Wait(AProc, RegisterSignal(ASignalName), ARunInMainThread, AData,
    AFreeType);
end;

function TQWorkers.Wait(AProc: TQJobProc; ASignalId: Integer;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Wait(AProc, ASignalId, ARunInMainThread,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams);
end;

function TQWorkers.Wait(AProc: TQJobProc; const ASignalName: QStringW;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Wait(AProc, RegisterSignal(ASignalName), ARunInMainThread,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams);
end;

function TQWorkers.Wait(AProc: TQJobProcG; ASignalId: Integer;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Wait(AProc, ASignalId, ARunInMainThread,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams);
end;

function TQWorkers.Wait(AProc: TQJobProcG; const ASignalName: QStringW;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Wait(AProc, RegisterSignal(ASignalName), ARunInMainThread,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams);
end;
{$IFDEF UNICODE}

function TQWorkers.Wait(AProc: TQJobProcA; ASignalId: Integer;
  ARunInMainThread: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
  ASignal: PQSignal;
begin
  if (not FTerminating) and Assigned(AProc) then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, AData, AFreeType, false, ARunInMainThread);
    AJob.WorkerProc.Method := MakeJobProc(AProc);
    AJob.SetFlags(JOB_SIGNAL_WAKEUP, true);
    AJob.PushTime := GetTimestamp;
    Result := 0;
    FLocker.Enter;
    try
      if (ASignalId >= 1) and (ASignalId <= FMaxSignalId) then
      begin
        ASignal := FSignalJobs[ASignalId - 1];
        AJob.Next := ASignal.First;
        ASignal.First := AJob;
        Result := AJob.Handle;
        Inc(FSignalJobCount);
      end;
    finally
      FLocker.Leave;
      if Result = 0 then
        JobPool.Push(AJob);
    end;
  end
  else
    Result := 0;
end;

function TQWorkers.Wait(AProc: TQJobProcA; const ASignalName: QStringW;
  ARunInMainThread: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Wait(AProc, RegisterSignal(ASignalName), ARunInMainThread, AData,
    AFreeType);
end;

function TQWorkers.Wait(AProc: TQJobProcA; const ASignalName: QStringW;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Wait(AProc, RegisterSignal(ASignalName), ARunInMainThread,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams);
end;

function TQWorkers.Wait(AProc: TQJobProcA; ASignalId: Integer;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
begin
  Result := Wait(AProc, ASignalId, ARunInMainThread,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams);
end;
{$ENDIF}

function TQWorkers.WaitJob(AHandle: IntPtr; ATimeout: Cardinal;
  AMsgWait: Boolean): TWaitResult;
var
  AFirst, AJob: PQJob;
  AChain: PQJobWaitChain;
  I: Integer;
  procedure AddWait;
  begin
    New(AChain);
    AChain.Event := TEvent.Create(nil, false, false, '');
    AChain.Job := AHandle;
    AChain.Prior := nil;
    FLocker.Enter;
    AChain.Prior := FLastWaitChain;
    FLastWaitChain := AChain;
    FLocker.Leave;
  end;
  procedure RemoveWait;
  var
    APrior, ANext: PQJobWaitChain;
  begin
    if Assigned(AChain) then
    begin
      ANext := nil;
      FLocker.Enter;
      try
        APrior := FLastWaitChain;
        while Assigned(APrior) do
        begin
          if APrior = AChain then
          begin
            if Assigned(ANext) then
              ANext.Prior := APrior.Prior
            else
              FLastWaitChain := APrior.Prior;
            Break;
          end;
          ANext := APrior;
          APrior := APrior.Prior;
        end;
      finally
        FLocker.Leave;
        FreeAndNil(AChain.Event);
        Dispose(AChain);
      end;
    end;
  end;

  procedure AbortWaits;
  var
    APrior: PQJobWaitChain;
  begin
    FLocker.Enter;
    try
      APrior := FLastWaitChain;
      while Assigned(APrior) do
      begin
        if APrior <> AChain then
          TEvent(APrior.Event).SetEvent;
        APrior := APrior.Prior;
      end;
    finally
      FLocker.Leave;
    end;
  end;

begin
  if (AHandle and $3) = 0 then
  begin
    AChain := nil;
    try
      AFirst := FSimpleJobs.PopAll;
      try
        AJob := AFirst;
        while AJob <> nil do
        begin
          if AHandle = IntPtr(AJob) then
          begin
            AddWait;
            Break;
          end
          else
            AJob := AJob.Next;
        end;
      finally
        FSimpleJobs.Repush(AFirst);
        LookupIdleWorker(false);
      end;
      if not Assigned(AChain) then
      begin
        FLocker.Enter;
        try
          for I := 0 to FWorkerCount - 1 do
          begin
            if IntPtr(FWorkers[I].FActiveJob) = AHandle then
            begin
              AddWait;
              Break;
            end;
          end;
        finally
          FLocker.Leave;
        end;
      end;
      if Assigned(AChain) then
      begin
        if AMsgWait then
        begin
          Result := MsgWaitForEvent(AChain.Event, ATimeout);
          if (Result = wrAbandoned) and AppTerminated then
            AbortWaits;
        end
        else
        begin
          if Terminating then
            Result := wrAbandoned
          else
            Result := TEvent(AChain.Event).WaitFor(ATimeout);
        end;
      end
      else
        Result := wrSignaled;
    finally
      RemoveWait;
    end;
  end
  else
    Result := wrError;
end;

function TQWorkers.Wait(AProc: TQJobProcG; ASignalId: Integer;
  ARunInMainThread: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Wait(TQJobProc(MakeJobProc(AProc)), ASignalId, ARunInMainThread,
    AData, AFreeType);
end;

function TQWorkers.Wait(AProc: TQJobProcG; const ASignalName: QStringW;
  ARunInMainThread: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Wait(AProc, RegisterSignal(ASignalName), ARunInMainThread, AData,
    AFreeType);
end;

procedure TQWorkers.WaitRunningDone(const AParam: TWorkerWaitParam;
  AMarkTerminateOnly: Boolean);
var
  AInMainThread: Boolean;
  function HasJobRunning: Boolean;
  var
    I: Integer;
    AJob: PQJob;
    AFound: Boolean;
  begin
    Result := false;
    DisableWorkers;
    FLocker.Enter;
    try
      for I := 0 to FWorkerCount - 1 do
      begin
        if FWorkers[I].IsLookuping then // ��δ�������������´β�ѯ
        begin
          Result := true;
          Break;
        end
        else if FWorkers[I].IsExecuting then
        begin
          AFound := false;
          if not FWorkers[I].IsCleaning then
          begin
            AJob := FWorkers[I].FActiveJob;
            case AParam.WaitType of
              0: // ByObject
                AFound := TMethod(FWorkers[I].FActiveJobProc)
                  .Data = AParam.Bound;
              1:
                // ByData
                AFound := (TMethod(FWorkers[I].FActiveJobProc)
                  .Code = TMethod(AParam.WorkerProc).Code) and
                  (TMethod(FWorkers[I].FActiveJobProc)
                  .Data = TMethod(AParam.WorkerProc).Data) and
                  ((AParam.Data = INVALID_JOB_DATA) or
                  (FWorkers[I].FActiveJobData = AParam.Data));
              2:
                // BySignalSource
                AFound := (FWorkers[I].FActiveJobSource = AParam.SourceJob);
              3, 5: // ByGroup,ByPlan: Group/PlanSource��ͬһ��ַ
                AFound := (FWorkers[I].FActiveJobGroup = AParam.Group);
              4:
                // ByJob
                AFound := (AJob = AParam.SourceJob);
              $FF: // ����
                AFound := true;
            else
              begin
                if Assigned(FOnError) then
                  FOnError(AJob, Exception.CreateFmt(SBadWaitDoneParam,
                    [AParam.WaitType]), jesWaitDone)
                else
                  raise Exception.CreateFmt(SBadWaitDoneParam,
                    [AParam.WaitType]);
              end;
            end;
            if AFound then
            begin
              FWorkers[I].FTerminatingJob := AJob;
              // ����Ƿ�ǰ�����߳���ֹͣ���߳���ҵ������ǵĻ������޷�ֹͣ�ģ�����ֻ�Ǳ��һ��
              if (not AMarkTerminateOnly) and AJob.InMainThread and
                (GetCurrentThreadId = MainThreadId) then
              begin
{$IFDEF DEBUG}
                raise Exception.Create(STerminateMainThreadJobInMainThread);
{$ENDIF}
                AMarkTerminateOnly := true;
              end;
              Result := true;
            end;
          end
          else
            Result := true;
        end;
      end;
    finally
      FLocker.Leave;
      EnableWorkers;
    end;
  end;

begin
  AInMainThread := GetCurrentThreadId = MainThreadId;
  repeat
    if HasJobRunning and (not AMarkTerminateOnly) then
    begin
      if AInMainThread then
        // ����������߳���������������ҵ���������߳�ִ�У������Ѿ�Ͷ����δִ�У����Ա��������ܹ�ִ��
        ProcessAppMessage;
      Sleep(10);
    end
    else // û�ҵ�
      Break;
  until 1 > 2;
end;

procedure TQWorkers.WaitSignalJobsDone(AJob: PQJob);
begin
  TEvent(AJob.Data).SetEvent;
end;

function TQWorkers.Clear(ASignalName: QStringW;
  AWaitRunningDone: Boolean): Integer;
var
  I: Integer;
  ASignal: PQSignal;
  AJob: PQJob;
begin
  Result := 0;
  FLocker.Enter;
  try
    AJob := nil;
    for I := 0 to FMaxSignalId - 1 do
    begin
      ASignal := FSignalJobs[I];
      if ASignal.Name = ASignalName then
      begin
        AJob := ASignal.First;
        while Assigned(ASignal.First) do
        begin
          Dec(FSignalJobCount);
          ASignal.First := ASignal.First.Next;
        end;
        ASignal.First := nil;
        Break;
      end;
    end;
  finally
    FLocker.Leave;
  end;
  if AJob <> nil then
    ClearSignalJobs(AJob, AWaitRunningDone);
end;
{$IFDEF UNICODE}

function TQWorkers.At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  AJob.Interval := AInterval;
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := At(TQJobProc(MakeJobProc(AProc)), ADelay, AInterval, AData,
    ARunInMainThread, AFreeType);
end;

function TQWorkers.At(AProc: TQJobProcG; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := At(TQJobProc(MakeJobProc(AProc)), ATime, AInterval, AData,
    ARunInMainThread, AFreeType);
end;

procedure TQWorkers.CheckWaitChain(AJob: PQJob);
  procedure NotifyIfWaiting;
  var
    AChain, APrior: PQJobWaitChain;
  begin
    AChain := FLastWaitChain;
    while Assigned(AChain) do
    begin
      APrior := AChain.Prior;
      if AChain.Job = IntPtr(AJob) then
      begin
        FLastWaitChain := AChain.Prior;
        TEvent(AChain.Event).SetEvent;
      end;
      AChain := APrior;
    end;
  end;

begin
  if Assigned(FLastWaitChain) then
  begin
    FLocker.Enter;
    try
      while Assigned(AJob) and Assigned(FLastWaitChain) do
      begin
        NotifyIfWaiting;
        AJob := AJob.Next;
      end;
    finally
      FLocker.Leave;
    end;
  end;
end;

function TQWorkers.Clear(ASignalId: Integer; AWaitRunningDone: Boolean)
  : Integer;
var
  AJob: PQJob;
begin
  FLocker.Enter;
  try
    if (ASignalId >= 1) and (ASignalId <= FMaxSignalId) then
    begin
      with FSignalJobs[ASignalId - 1]^ do
      begin
        AJob := First;
        while Assigned(First) do
        begin
          Dec(FSignalJobCount);
          First := First.Next;
        end;
      end;
    end
    else
      AJob := nil;
  finally
    FLocker.Leave;
  end;
  if AJob <> nil then
    Result := ClearSignalJobs(AJob, AWaitRunningDone)
  else
    Result := 0;
end;
{$IFDEF UNICODE}

function TQWorkers.Clear(AProc: TQJobProcA; AData: Pointer; AMaxTimes: Integer;
  AWaitRunningDone: Boolean): Integer;
begin
  Result := Clear(TQJobProc(MakeJobProc(AProc)), AData, AMaxTimes,
    AWaitRunningDone);
end;
{$ENDIF}

function TQWorkers.Clear(AProc: TQJobProcG; AData: Pointer; AMaxTimes: Integer;
  AWaitRunningDone: Boolean): Integer;
begin
  Result := Clear(TQJobProc(MakeJobProc(AProc)), AData, AMaxTimes,
    AWaitRunningDone);
end;

procedure TQWorkers.Clear(AWaitRunningDone: Boolean);
var
  I: Integer;
  AParam: TWorkerWaitParam;
  ASignal: PQSignal;
begin
  DisableWorkers; // ���⹤����ȡ���µ���ҵ
  try
    FSimpleJobs.Clear;
    FRepeatJobs.Clear;
    FPlanJobs.Clear;
    FLocker.Enter;
    try
      for I := 0 to FMaxSignalId - 1 do
      begin
        ASignal := FSignalJobs[I];
        FreeJob(ASignal.First);
        ASignal.First := nil;
      end;
      FSignalJobCount := 0;
    finally
      FLocker.Leave;
    end;
    AParam.WaitType := $FF;
    WaitRunningDone(AParam, not AWaitRunningDone);
  finally
    EnableWorkers;
  end;
end;

function TQWorkers.ClearSignalJobs(ASource: PQJob;
  AWaitRunningDone: Boolean): Integer;
var
  AFirst, ALast, APrior, ANext: PQJob;
  ACount: Integer;
  AWaitParam: TWorkerWaitParam;
begin
  Result := 0;
  AFirst := nil;
  APrior := nil;
  FSimpleJobs.FLocker.Enter;
  try
    ALast := FSimpleJobs.FFirst;
    ACount := FSimpleJobs.Count;
    FSimpleJobs.FFirst := nil;
    FSimpleJobs.FLast := nil;
    FSimpleJobs.FCount := 0;
  finally
    FSimpleJobs.FLocker.Leave;
  end;
  while ALast <> nil do
  begin
    if (ALast.IsSignalWakeup) and (ALast.Source = ASource) then
    begin
      ANext := ALast.Next;
      ALast.Next := nil;
      FreeJob(ALast);
      ALast := ANext;
      if APrior <> nil then
        APrior.Next := ANext;
      Dec(ACount);
      Inc(Result);
    end
    else
    begin
      if AFirst = nil then
        AFirst := ALast;
      APrior := ALast;
      ALast := ALast.Next;
    end;
  end;
  if ACount > 0 then
  begin
    FSimpleJobs.FLocker.Enter;
    try
      APrior.Next := FSimpleJobs.FFirst;
      FSimpleJobs.FFirst := AFirst;
      Inc(FSimpleJobs.FCount, ACount);
      if FSimpleJobs.FLast = nil then
        FSimpleJobs.FLast := APrior;
    finally
      FSimpleJobs.FLocker.Leave;
    end;
  end;
  AWaitParam.WaitType := 2;
  AWaitParam.SourceJob := ASource;
  WaitRunningDone(AWaitParam, not AWaitRunningDone);
  FreeJob(ASource);
end;
{$IFDEF UNICODE}

function TQWorkers.Post(AProc: TQJobProcA; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  AJob.Interval := AInterval;
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProcA; AInterval: Int64;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, AInterval <= 0, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  AJob.Interval := AInterval;
  Result := Post(AJob);
end;

{$ENDIF}

function TQWorkers.Post(AProc: TQJobProcG; AInterval: Int64;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, AInterval <= 0, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  AJob.Interval := AInterval;
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProc; AInterval: Int64;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, AInterval <= 0, ARunInMainThread);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  AJob.Interval := AInterval;
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProcG;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean;
  AInsertToFirst: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, true, ARunInMainThread);
  AJob.AsFirst := AInsertToFirst;
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProc;
  const AParams: array of TQJobParamPair; ARunInMainThread: Boolean;
  AInsertToFirst: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, Pointer(TQJobParams.Create(AParams) as IQJobNamedParams),
    jdfFreeAsParams, true, ARunInMainThread);
  AJob.AsFirst := AInsertToFirst;
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  Result := Post(AJob);
end;

function TQWorkers.PostSignal(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType): Boolean;
begin
  Result := SignalQueue.Post(AId, AData, AFreeType);
end;

function TQWorkers.PostSignal(const AName: QStringW; AData: Pointer;
  AFreeType: TQJobDataFreeType): Boolean;
begin
  Result := SignalQueue.Post(AName, AData, AFreeType);
end;

function TQWorkers.Post(AProc: TQJobProcG; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Post(TQJobProc(MakeJobProc(AProc)), AInterval, AData,
    ARunInMainThread, AFreeType);
end;

procedure TQWorkers.ClearSingleJob(AHandle: IntPtr; AWaitRunningDone: Boolean);
var
  AInstance: PQJob;
  AWaitParam: TWorkerWaitParam;

  function RemoveSignalJob: PQJob;
  var
    I: Integer;
    AJob, ANext, APrior: PQJob;
    ASignal: PQSignal;
  begin
    Result := nil;
    FLocker.Enter;
    try
      for I := 0 to FMaxSignalId - 1 do
      begin
        ASignal := FSignalJobs[I];
        AJob := ASignal.First;
        APrior := nil;
        while Assigned(AJob) do
        begin
          ANext := AJob.Next;
          if AJob = AInstance then
          begin
            if ASignal.First = AJob then
              ASignal.First := ANext;
            if Assigned(APrior) then
              APrior.Next := ANext;
            AJob.Next := nil;
            Result := AJob;
            Dec(FSignalJobCount);
            Exit;
          end
          else
            APrior := AJob;
          AJob := ANext;
        end;
      end;
    finally
      FLocker.Leave;
    end;
  end;
  function ClearSignalJob: Boolean;
  var
    AJob: PQJob;
  begin
    AJob := RemoveSignalJob;
    if Assigned(AJob) then
      ClearSignalJobs(AJob, AWaitRunningDone);
    Result := AJob <> nil;
  end;

begin
  AInstance := HandleToJob(AHandle);
  FillChar(AWaitParam, SizeOf(TWorkerWaitParam), 0);
  AWaitParam.SourceJob := AInstance;
  case AHandle and $03 of
    0:
      // SimpleJobs
      begin
        if FSimpleJobs.Clear(AHandle) then // ����ҵҪô�ڶ����У�Ҫô����
          Exit;
        AWaitParam.WaitType := 4;
      end;
    1: // RepeatJobs
      begin
        if not FRepeatJobs.Clear(IntPtr(AInstance)) then
          // �ظ�����������ڶ����У�˵���Ѿ��������
          Exit;
        AWaitParam.WaitType := 2;
      end;
    2: // SignalJobs;
      begin
        if ClearSignalJob then
          Exit;
        AWaitParam.WaitType := 2;
      end;
    3: // �ƻ�����
      begin
        FPlanJobs.Clear(IntPtr(AInstance));
        // �ƻ�����Ҫô�ڶ����У�Ҫô��ִ����
        AWaitParam.WaitType := 5;
      end;
  end;
  WaitRunningDone(AWaitParam, not AWaitRunningDone);
end;

function TQWorkers.ClearJobs(AHandles: PIntPtr; ACount: Integer;
  AWaitRunningDone: Boolean): Integer;
var
  ASimpleHandles: array of IntPtr;
  APlanHandles: array of IntPtr;
  ARepeatHandles: array of IntPtr;
  ASignalHandles: array of IntPtr;
  ASimpleCount, ARepeatCount, ASignalCount, APlanCount: Integer;
  I: Integer;
  AWaitParam: TWorkerWaitParam;

  function SignalJobCanRemove(AHandle: IntPtr): Boolean;
  var
    T: Integer;
  begin
    Result := false;
    for T := 0 to ASignalCount - 1 do
    begin
      if ASignalHandles[T] = AHandle then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;

  function ClearSignals: Integer;
  var
    I: Integer;
    AJob, ANext, APrior, AFirst: PQJob;
    ASignal: PQSignal;
  begin
    Result := 0;
    AFirst := nil;
    FLocker.Enter;
    try
      for I := 0 to FMaxSignalId - 1 do
      begin
        ASignal := FSignalJobs[I];
        AJob := ASignal.First;
        APrior := nil;
        while AJob <> nil do
        begin
          ANext := AJob.Next;
          if SignalJobCanRemove(IntPtr(AJob)) then
          begin
            if ASignal.First = AJob then
              ASignal.First := ANext;
            if Assigned(APrior) then
              APrior.Next := ANext;
            AJob.Next := nil;
            if Assigned(AFirst) then
              AJob.Next := AFirst;
            AFirst := AJob;
          end
          else
            APrior := AJob;
          AJob := ANext;
          Inc(Result);
        end;
      end;
    finally
      FLocker.Leave;
    end;
    while AFirst <> nil do
    begin
      ANext := AFirst.Next;
      AFirst.Next := nil;
      ClearSignalJobs(AFirst);
      AFirst := ANext;
    end;
  end;

begin
  Result := 0;
  SetLength(ASimpleHandles, ACount);
  SetLength(ARepeatHandles, ACount);
  SetLength(ASignalHandles, ACount);
  SetLength(APlanHandles, ACount);
  ASimpleCount := 0;
  ARepeatCount := 0;
  ASignalCount := 0;
  APlanCount := 0;
  I := 0;
  while I < ACount do
  begin
    case (IntPtr(AHandles^) and $03) of
      0:
        // Simple Jobs
        begin
          ASimpleHandles[ASimpleCount] := (IntPtr(AHandles^) and (not $03));
          Inc(ASimpleCount);
        end;
      1: // RepeatJobs
        begin
          ARepeatHandles[ARepeatCount] := (IntPtr(AHandles^) and (not $03));
          Inc(ARepeatCount);
        end;
      2: // SignalJobs
        begin
          ASignalHandles[ASignalCount] := (IntPtr(AHandles^) and (not $03));
          Inc(ASignalCount);
        end;
      3: // Plan job
        begin
          APlanHandles[APlanCount] := IntPtr(HandleToJob(AHandles^));
          Inc(APlanCount);
        end;
    end;
    Inc(I);
  end;
  if APlanCount > 0 then
    Inc(Result, FPlanJobs.Clear(@APlanHandles[0], APlanCount));
  if ASimpleCount > 0 then
    Inc(Result, FSimpleJobs.Clear(@ASimpleHandles[0], ASimpleCount));
  if ARepeatCount > 0 then
    Inc(Result, FRepeatJobs.Clear(@ARepeatHandles[0], ARepeatCount));
  if ASignalCount > 0 then
    Inc(Result, ClearSignals);
  if AWaitRunningDone then
  begin
    FillChar(AWaitParam, SizeOf(TWorkerWaitParam), 0);
    I := 0;
    while I < ASimpleCount do
    begin
      if ASimpleHandles[I] <> 0 then
      begin
        AWaitParam.SourceJob := Pointer(ASimpleHandles[I]);
        AWaitParam.WaitType := 4;
        WaitRunningDone(AWaitParam);
        Inc(Result);
      end;
      Inc(I);
    end;
    I := 0;
    while I < ASimpleCount do
    begin
      if ASimpleHandles[I] <> 0 then
      begin
        AWaitParam.SourceJob := Pointer(APlanHandles[I]);
        AWaitParam.WaitType := 5;
        WaitRunningDone(AWaitParam);
        Inc(Result);
      end;
      Inc(I);
    end;
    I := 0;
    while I < ARepeatCount do
    begin
      if ARepeatHandles[I] <> 0 then
      begin
        AWaitParam.SourceJob := Pointer(ARepeatHandles[I]);
        AWaitParam.WaitType := 2;
        WaitRunningDone(AWaitParam);
        Inc(Result);
      end;
    end;
  end;
end;

function TQWorkers.Signal(const AName: QStringW;
  const AParams: array of TQJobParamPair; AWaitTimeout: Cardinal): TWaitResult;
begin
  Result := SignalQueue.Send(AName,
    Pointer(TQJobParams.Create(AParams) as IQJobNamedParams), jdfFreeAsParams,
    AWaitTimeout);
end;

{ TJobPool }

constructor TJobPool.Create(AMaxSize: Integer);
begin
  inherited Create;
  FSize := AMaxSize;
  FLocker := TQSimpleLock.Create;
end;

destructor TJobPool.Destroy;
var
  AJob: PQJob;
begin
  FLocker.Enter;
  while FFirst <> nil do
  begin
    AJob := FFirst.Next;
    Dispose(FFirst);
    FFirst := AJob;
  end;
  FreeObject(FLocker);
  inherited;
end;

function TJobPool.Pop: PQJob;
begin
  FLocker.Enter;
  Result := FFirst;
  if Result <> nil then
  begin
    FFirst := Result.Next;
    Dec(FCount);
  end;
  FLocker.Leave;
  if Result = nil then
    GetMem(Result, SizeOf(TQJob));
  Result.Reset;
end;

procedure TJobPool.Push(AJob: PQJob);
var
  ADoFree: Boolean;
begin
{$IFDEF UNICODE}
  if AJob.IsAnonWorkerProc then
    TQJobProcA(AJob.WorkerProc.ProcA) := nil
  else
    PQJobProc(@AJob.WorkerProc)^ := nil;
{$ENDIF}
  FLocker.Enter;
  ADoFree := (FCount = FSize);
  if not ADoFree then
  begin
    AJob.Next := FFirst;
    FFirst := AJob;
    Inc(FCount);
  end;
  FLocker.Leave;
  if ADoFree then
  begin
    FreeMem(AJob);
  end;
end;

{ TQSimpleLock }
{$IFDEF QWORKER_SIMPLE_LOCK}

constructor TQSimpleLock.Create;
begin
  inherited;
  FFlags := 0;
end;

procedure TQSimpleLock.Enter;
begin
  while (AtomicOr(FFlags, $01) and $01) <> 0 do
  begin
    GiveupThread;
  end;
end;

procedure TQSimpleLock.Leave;
begin
  AtomicAnd(FFlags, Integer($FFFFFFFE));
end;
{$ENDIF QWORKER_SIMPLE_JOB}
{ TQJobGroup }

function TQJobGroup.Add(AProc: TQJobProc; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := InternalAddJob(AJob);
end;

function TQJobGroup.Add(AProc: TQJobProcG; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
begin
  Result := Add(TQJobProc(MakeJobProc(AProc)), AData, AInMainThread, AFreeType);
end;
{$IFDEF UNICODE}

function TQJobGroup.Add(AProc: TQJobProcA; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  Result := InternalAddJob(AJob);
end;

procedure TQJobGroup.BeginWaiting;
begin
  AtomicIncrement(FWaitingCount);
end;

{$ENDIF}

function TQJobGroup.Add(AJob: PQJob): Boolean;
begin
  AJob.Group := Self;
  AJob.SetFlags(JOB_GROUPED, true);
  AJob.PushTime := 0;
  Result := InternalAddJob(AJob);
  if not Result then
    Workers.FreeJob(AJob);
end;

procedure TQJobGroup.Cancel(AWaitRunningDone: Boolean);
var
  I: Integer;
  AJob: PQJob;
  AWaitParam: TWorkerWaitParam;
begin
  FLocker.Enter;
  try
    AtomicExchange(FCanceled, 0);
    if FByOrder then
    begin
      I := 0;
      while I < FItems.Count do
      begin
        AJob := FItems[I];
        if AJob.PopTime = 0 then
        begin
          Workers.FreeJob(AJob);
          FItems.Delete(I);
          AtomicIncrement(FCanceled);
        end
        else
          Inc(I);
      end;
    end;
    FItems.Clear;
  finally
    FLocker.Leave;
  end;
  if FPosted <> 0 then
  begin
    I := Workers.FSimpleJobs.Clear(Self, MaxInt);
    if I > 0 then
    begin
      AtomicIncrement(FPosted, -I);
      AtomicIncrement(FCanceled, I);
    end;
    if AWaitRunningDone then
    begin
      AWaitParam.WaitType := 3;
      AWaitParam.Group := Self;
      Workers.WaitRunningDone(AWaitParam);
    end;
  end;
  if FPosted = 0 then
  begin
    if FCanceled > 0 then
      FWaitResult := wrAbandoned;
    if FWaitingCount > 0 then
      FEvent.SetEvent;
  end;
end;

constructor TQJobGroup.Create(AByOrder: Boolean);
begin
  inherited Create;
  FEvent := TEvent.Create(nil, false, false, '');
  FLocker := TQSimpleLock.Create;
  FByOrder := AByOrder;
  FItems := TQJobItemList.Create;
  // DebugOut('!!!GROUP %x CREATED', [IntPtr(Self)]);
end;

destructor TQJobGroup.Destroy;
var
  I: Integer;
begin
  FFreeAfterDone := False;
  Cancel;
  if FTimeoutCheck then
    Workers.Clear(Self, 1);
  FLocker.Enter;
  try
    if FItems.Count > 0 then
    begin
      FWaitResult := wrAbandoned;
      FEvent.SetEvent;
      for I := 0 to FItems.Count - 1 do
      begin
        if PQJob(FItems[I]).PushTime <> 0 then
          JobPool.Push(FItems[I]);
      end;
      FItems.Clear;
    end;
  finally
    FLocker.Leave;
  end;
  FreeAndNil(FLocker);
  FreeAndNil(FEvent);
  FreeAndNil(FItems);
  // DebugOut('!!!GROUP %x FREE', [IntPtr(Self)]);
  inherited;
end;

procedure TQJobGroup.DoAfterDone;
begin
  try
    if Assigned(FAfterDone) then
      FAfterDone(Self);
  finally
    if FFreeAfterDone then
      FreeObject(Self);
  end;
end;

procedure TQJobGroup.DoJobExecuted(AJob: PQJob);
var
  I: Integer;
  AIsDone: Boolean;
begin
  AtomicIncrement(FRuns);
  if FWaitResult = wrIOCompletion then
  begin
    if AppTerminated then
      Cancel(False);
    AIsDone := false;
    FLocker.Enter;
    try
      I := FItems.IndexOf(AJob);
      if I <> -1 then
      begin
        FItems.Delete(I);
        if FItems.Count = 0 then
        begin
          AIsDone := true;
          FWaitResult := wrSignaled;
          AtomicExchange(FPosted, 0);
        end
        else if ByOrder then
        begin
          if Workers.Post(FItems[0]) = 0 then
          begin
            AtomicDecrement(FPosted);
            FItems.Delete(0);
            // Ͷ��ʧ��ʱ��Post�Զ��ͷ�����ҵ
            FWaitResult := wrAbandoned;
            AIsDone := true;
          end
        end
        else if (FMaxWorkers > 0) and (FPosted <= FMaxWorkers) and
          (FPosted <= FItems.Count) then
        begin
          if Workers.Post(FItems[FPosted - 1]) = 0 then
          begin
            AtomicDecrement(FPosted);
            FItems.Delete(0);
            // Ͷ��ʧ��ʱ��Post�Զ��ͷ�����ҵ
            FWaitResult := wrAbandoned;
            AIsDone := true;
          end
        end
        else
          AtomicDecrement(FPosted);
      end
      else
      begin
        AIsDone := (FItems.Count = 0) and (AtomicDecrement(FPosted) = 0);
        if AIsDone then
        begin
          if FCanceled = 0 then
            FWaitResult := wrSignaled
          else
          begin
            FWaitResult := wrAbandoned;
            AtomicExchange(FCanceled, 0);
          end;
        end;
      end;
    finally
      FLocker.Leave;
    end;
    if AIsDone then
    begin
      FEvent.SetEvent;
      if FWaitingCount = 0 then
        DoAfterDone;
    end;
  end;
end;

procedure TQJobGroup.DoJobsTimeout(AJob: PQJob);
begin
  FTimeoutCheck := false;
  Cancel;
  if FWaitResult = wrIOCompletion then
  begin
    FWaitResult := wrTimeout;
    FEvent.SetEvent;
    DoAfterDone;
  end;
end;

procedure TQJobGroup.EndWaiting;
begin
  if AtomicDecrement(FWaitingCount) = 0 then
    DoAfterDone;
end;

function TQJobGroup.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQJobGroup.InitGroupJob(AData: Pointer; AInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): PQJob;
begin
  Result := JobPool.Pop;
  JobInitialize(Result, AData, AFreeType, true, AInMainThread);
  Result.Group := Self;
  Result.SetFlags(JOB_GROUPED, true);
end;

function TQJobGroup.Insert(AIndex: Integer; AProc: TQJobProc; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc.Proc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := InternalInsertJob(AIndex, AJob);
end;

function TQJobGroup.Insert(AIndex: Integer; AProc: TQJobProcG; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
  AJob.WorkerProc.ProcG := AProc;
  Result := InternalInsertJob(AIndex, AJob);
end;
{$IFDEF UNICODE}

function TQJobGroup.Insert(AIndex: Integer; AProc: TQJobProcA; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
  AJob.WorkerProc.Method := MakeJobProc(AProc);
  Result := InternalInsertJob(AIndex, AJob);
end;
{$ENDIF}

function TQJobGroup.InternalAddJob(AJob: PQJob): Boolean;
begin
  FLocker.Enter;
  try
    FWaitResult := wrIOCompletion;
    if (FPrepareCount > 0) or ((FMaxWorkers > 0) and (FPosted >= FMaxWorkers))
    then
    // ����������Ŀ�����Ѿ������������������ޣ���ӵ��б��У��ȴ�Run������ҵ���
    begin
      FItems.Add(AJob);
      Result := true;
    end
    else
    begin
      if ByOrder then
      // ��˳��
      begin
        Result := true;
        FItems.Add(AJob);
        if FItems.Count = 1 then
          Result := Workers.Post(AJob) <> 0;
      end
      else
      begin
        Result := Workers.Post(AJob) <> 0;
        if Result then
          FItems.Add(AJob);
      end;
      if Result then
        AtomicIncrement(FPosted);
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQJobGroup.InternalInsertJob(AIndex: Integer; AJob: PQJob): Boolean;
begin
  FLocker.Enter;
  try
    FWaitResult := wrIOCompletion;
    if AIndex > FItems.Count then
      AIndex := FItems.Count
    else if AIndex < 0 then
      AIndex := 0;
    if (FPrepareCount > 0) or ((FMaxWorkers > 0) and (FPosted >= FMaxWorkers))
    then
    // ����������Ŀ�����Ѿ������������������ޣ���ӵ��б��У��ȴ�Run������ҵ���
    begin
      FItems.Insert(AIndex, AJob);
      Result := true;
    end
    else
    begin
      if ByOrder then // ��˳��
      begin
        Result := true;
        FItems.Insert(AIndex, AJob);
        if FItems.Count = 1 then
          Result := Workers.Post(AJob) <> 0;
      end
      else
      // ����˳�򴥷�ʱ�����AIndex��Ϊ0����ȼ���Add������ֱ�Ӳ������ҵ�б��г�Ϊ�׸���������ҵ
      begin
        if AIndex = 0 then
          AJob.AsFirst := true;
        Result := Workers.Post(AJob) <> 0;
        if Result then
          FItems.Add(AJob);
      end;
      if Result then
        AtomicIncrement(FPosted);
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQJobGroup.MsgWaitFor(ATimeout: Cardinal): TWaitResult;
var
  AEmpty: Boolean;
begin
  BeginWaiting;
  try
    Result := FWaitResult;
    if GetCurrentThreadId <> MainThreadId then
      Result := WaitFor(ATimeout)
    else
    begin
      FLocker.Enter;
      try
        AEmpty := FItems.Count = 0;
        if AEmpty then
          Result := wrSignaled;
      finally
        FLocker.Leave;
      end;
      if Result = wrIOCompletion then
      begin
        if MsgWaitForEvent(FEvent, ATimeout) = wrSignaled then
          Result := FWaitResult;

        if Result = wrIOCompletion then
        begin
          Cancel;
          if Result = wrIOCompletion then
            Result := wrTimeout;
        end;
        if FTimeoutCheck then
          Workers.Clear(Self);
      end;
    end;
  finally
    EndWaiting;
  end;
end;

procedure TQJobGroup.Prepare;
begin
  AtomicIncrement(FPrepareCount);
end;

procedure TQJobGroup.Run(ATimeout: Cardinal);
var
  I: Integer;
  AJob: PQJob;
begin
  if AtomicDecrement(FPrepareCount) = 0 then
  begin
    if ATimeout <> INFINITE then
    begin
      FTimeoutCheck := true;
      Workers.Delay(DoJobsTimeout, ATimeout * 10, nil);
    end;
    FLocker.Enter;
    try
      if FItems.Count = 0 then
        FWaitResult := wrSignaled
      else
      begin
        FWaitResult := wrIOCompletion;
        if ByOrder then
        begin
          AJob := FItems[0];
          if (AJob.PushTime = 0) then
          begin
            if Workers.Post(AJob) = 0 then
              FWaitResult := wrAbandoned
            else
              AtomicIncrement(FPosted);
          end;
        end
        else if (FMaxWorkers <= 0) or (FPosted < FMaxWorkers) then
        begin
          for I := 0 to FItems.Count - 1 do
          begin
            AJob := FItems[I];
            if AJob.PushTime = 0 then
            begin
              if Workers.Post(AJob) = 0 then
              begin
                FWaitResult := wrAbandoned;
                Break;
              end
              else
                AtomicIncrement(FPosted);
              if FPosted = FMaxWorkers then
                Break;
            end;
          end;
        end;
      end;
    finally
      FLocker.Leave;
    end;
    if FWaitResult <> wrIOCompletion then
    begin
      FEvent.SetEvent;
      DoAfterDone;
    end;
    // DebugOut('Posted remain %d',[FPosted]);
  end;
end;

function TQJobGroup.WaitFor(ATimeout: Cardinal): TWaitResult;
var
  AEmpty: Boolean;
begin
  BeginWaiting;
  try
    Result := FWaitResult;
    FLocker.Enter;
    try
      AEmpty := FItems.Count = 0;
      if AEmpty then
        Result := wrSignaled;
    finally
      FLocker.Leave;
    end;
    if Result = wrIOCompletion then
    begin
      if FEvent.WaitFor(ATimeout) = wrSignaled then
        Result := FWaitResult
      else
      begin
        Result := wrTimeout;
        Cancel;
      end;
    end;
    if FTimeoutCheck then
      Workers.Clear;
  finally
    EndWaiting;
  end;
end;

function JobPoolCount: NativeInt;
begin
  Result := JobPool.Count;
end;

function JobPoolPrint: QStringW;
var
  AJob: PQJob;
  ABuilder: TQStringCatHelperW;
begin
  ABuilder := TQStringCatHelperW.Create;
  JobPool.FLocker.Enter;
  try
    AJob := JobPool.FFirst;
    while AJob <> nil do
    begin
      ABuilder.Cat(IntToHex(NativeInt(AJob), SizeOf(NativeInt)))
        .Cat(SLineBreak);
      AJob := AJob.Next;
    end;
  finally
    JobPool.FLocker.Leave;
    Result := ABuilder.Value;
    FreeObject(ABuilder);
  end;
end;

{ TQForJobs }
procedure TQForJobs.BreakIt;
begin
  AtomicExchange(FBreaked, 1);
end;

constructor TQForJobs.Create(const AStartIndex, AStopIndex: TForLoopIndexType;
  AData: Pointer; AFreeType: TQJobDataFreeType);
var
  ACount: NativeInt;
begin
  inherited Create;
  FIterator := AStartIndex - 1;
  FStartIndex := AStartIndex;
  FStopIndex := AStopIndex;
  FWorkerCount := GetCPUCount;
  ACount := (AStopIndex - AStartIndex) + 1;
  if FWorkerCount > ACount then
    FWorkerCount := ACount;
  FWorkJob := JobPool.Pop;
  JobInitialize(FWorkJob, AData, AFreeType, true, false);
  FEvent := TEvent.Create();
end;

destructor TQForJobs.Destroy;
begin
  Workers.FreeJob(FWorkJob);
  FreeObject(FEvent);
  inherited;
end;

procedure TQForJobs.DoJob(AJob: PQJob);
var
  I: NativeInt;
begin
  repeat
    I := AtomicIncrement(FIterator);
    if I <= StopIndex then
    begin
      try
{$IFDEF UNICODE}
        if FWorkJob.IsAnonWorkerProc then
          TQForJobProcA(FWorkJob.WorkerProc.ForProcA)(Self, FWorkJob, I)
        else
{$ENDIF}
          if FWorkJob.WorkerProc.Data = nil then
            FWorkJob.WorkerProc.ForProcG(Self, FWorkJob, I)
          else
            PQForJobProc(@FWorkJob.WorkerProc)^(Self, FWorkJob, I);
      except
        on E: Exception do
      end;
      AtomicIncrement(FWorkJob.Runs);
    end
    else
      Break;
  until (FIterator > StopIndex) or (FBreaked <> 0) or (AJob.IsTerminated);
  if AJob.IsTerminated then
    BreakIt;
  if AtomicDecrement(FWorkerCount) = 0 then
    FEvent.SetEvent;
end;
{$IFDEF UNICODE}

class function TQForJobs.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcA; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
var
  AInst: TQForJobs;
begin
  AInst := TQForJobs.Create(AStartIndex, AStopIndex, AData, AFreeType);
  try
    AInst.FWorkJob.WorkerProc.ForProc := nil;
    AInst.FWorkJob.WorkerProc.Data := Pointer(-1);
    TQForJobProcA(AInst.FWorkJob.WorkerProc.Code) := AWorkerProc;
    AInst.Start;
    Result := AInst.Wait(AMsgWait);
  finally
    FreeObject(AInst);
  end;
end;
{$ENDIF}

class function TQForJobs.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcG; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
var
  AInst: TQForJobs;
begin
  AInst := TQForJobs.Create(AStartIndex, AStopIndex, AData, AFreeType);
  try
    AInst.FWorkJob.WorkerProc.ForProcG := AWorkerProc;
    AInst.Start;
    Result := AInst.Wait(AMsgWait);
  finally
    FreeObject(AInst);
  end;
end;

class function TQForJobs.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProc; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
var
  AInst: TQForJobs;
begin
  AInst := TQForJobs.Create(AStartIndex, AStopIndex, AData, AFreeType);
  try
    PQForJobProc(@AInst.FWorkJob.WorkerProc)^ := AWorkerProc;
    AInst.Start;
    Result := AInst.Wait(AMsgWait);
  finally
    FreeObject(AInst);
  end;
end;

function TQForJobs.GetAvgTime: Cardinal;
begin
  if Runs > 0 then
    Result := TotalTime div Runs
  else
    Result := 0;
end;

function TQForJobs.GetBreaked: Boolean;
begin
  Result := FBreaked <> 0;
end;

function TQForJobs.GetRuns: Cardinal;
begin
  Result := FWorkJob.Runs;
end;

function TQForJobs.GetTotalTime: Cardinal;
begin
  Result := FWorkJob.TotalUsedTime;
end;

procedure TQForJobs.Run(AWorkerProc: TQForJobProc; AMsgWait: Boolean);
begin
  PQForJobProc(@FWorkJob.WorkerProc.ForProc)^ := AWorkerProc;
  Start;
  Wait(AMsgWait);
end;

procedure TQForJobs.Run(AWorkerProc: TQForJobProcG; AMsgWait: Boolean);
begin
  FWorkJob.WorkerProc.ForProcG := AWorkerProc;
  Start;
  Wait(AMsgWait);
end;
{$IFDEF UNICODE}

procedure TQForJobs.Run(AWorkerProc: TQForJobProcA; AMsgWait: Boolean);
begin
  TQForJobProcA(FWorkJob.WorkerProc.ForProcA) := AWorkerProc;
  Start;
  Wait(AMsgWait);
end;
{$ENDIF}

procedure TQForJobs.Start;
var
  I: Integer;
begin
  FWorkJob.StartTime := GetTimestamp;
  Workers.DisableWorkers;
  for I := 0 to FWorkerCount - 1 do
    Workers.Post(DoJob, nil);
  Workers.EnableWorkers;
end;

function TQForJobs.Wait(AMsgWait: Boolean): TWaitResult;
begin
  if FWorkerCount > 0 then
  begin
    if AMsgWait then
      Result := MsgWaitForEvent(FEvent, INFINITE)
    else
      Result := FEvent.WaitFor(INFINITE);
    if FBreaked <> 0 then
      Result := wrAbandoned;
  end
  else
    Result := wrSignaled;
  FWorkJob.TotalUsedTime := GetTimestamp - FWorkJob.StartTime;
end;

{ TStaticThread }

procedure TStaticThread.CheckNeeded;
begin
  FEvent.SetEvent;
end;

constructor TStaticThread.Create;
begin
  inherited Create(true);
  FEvent := TEvent.Create(nil, false, false, '');
{$IFDEF MSWINDOWS}
  Priority := tpIdle;
{$ENDIF}
end;

destructor TStaticThread.Destroy;
begin
  FreeObject(FEvent);
  inherited;
end;

procedure TStaticThread.Execute;
var
  AWaitTime: Cardinal;
  // ����ĩ1���CPUռ���ʣ��������60%����δ��������ҵ������������Ĺ������������ҵ
  function LastCpuUsage: Integer;
{$IFDEF MSWINDOWS}
  var
    CurSystemTimes: TSystemTimes;
    Usage, Idle: UInt64;
{$ENDIF}
  begin
{$IFDEF MSWINDOWS}
    Result := 0;
    if WinGetSystemTimes(PFileTime(@CurSystemTimes.IdleTime)^,
      PFileTime(@CurSystemTimes.KernelTime)^,
      PFileTime(@CurSystemTimes.UserTime)^) then
    begin
      if FLastTimes.IdleTime > 0 then
      begin
        Usage := (CurSystemTimes.UserTime - FLastTimes.UserTime) +
          (CurSystemTimes.KernelTime - FLastTimes.KernelTime) +
          (CurSystemTimes.NiceTime - FLastTimes.NiceTime);
        Idle := CurSystemTimes.IdleTime - FLastTimes.IdleTime;
        if Usage > Idle then
          Result := Trunc((Usage - Idle) * 100.0 / Usage);
      end;
      FLastTimes := CurSystemTimes;
    end
{$ELSE}
    Result := TThread.GetCPUUsage(FLastTimes);
{$ENDIF}
  end;
  procedure CheckFrozenJobs;
  var
    I, ACount: Integer;
    AJobs: array of PQJob;
    AJob: PQJob;
    ATime, AFrozenTime: Int64;
  begin
    ATime := GetTimestamp;
    ACount := 0;
    with Workers do
    begin
      AFrozenTime := JobFrozenTime * Q1Second;
      DisableWorkers;
      FLocker.Enter;
      try
        SetLength(AJobs, Workers);
        for I := 0 to Workers - 1 do
        begin
          AJob := FWorkers[I].FActiveJob;
          // ����ִ����ҵ�����߳���ҵ������г�ʱ��飬��������߳���ҵ�������û������� ForceQuit ǿ����ҵ����
          if Assigned(AJob) and (not AJob.IsLongtimeJob) and
            ((ATime - AJob.StartTime) > AFrozenTime) then
          begin
            AJobs[ACount] := AJob;
            Inc(ACount);
          end;
        end;
      finally
        FLocker.Leave;
        EnableWorkers;
      end;
      for I := 0 to ACount - 1 do
        OnJobFrozen(AJobs[I]);
    end;
  end;
// ��ʱ�����������
  function NextTimeout: Cardinal;
  var
    H, N, S, MS: Word;
  begin
    DecodeTime(Now, H, N, S, MS);
    // �������
    Result := 1000 - MS;
  end;
  procedure CheckPlans;
  begin
    if Workers.FPlanJobs.Count > 0 then
      Workers.DoPlanCheck;
  end;

begin
{$IFDEF MSWINDOWS}
{$IF RTLVersion>=21}
  NameThreadForDebugging('QStaticThread');
{$IFEND >=2010}
{$ENDIF}
  while not Terminated do
  begin
    AWaitTime := NextTimeout;
    case FEvent.WaitFor(AWaitTime) of
      wrSignaled:
        begin
          if Assigned(Workers) and (not Workers.Terminating) and
            (Workers.IdleWorkers = 0) then
            Workers.LookupIdleWorker(false);
        end;
      wrTimeout:
        begin
          // �����û����泤ʱ������ʱ����������¼ƻ���ҵ��������ֹ��ԭ����DoPlanCheck��ҵ��������ֹ���������¼��
          TDLLMainThreadSyncHelper.Current.HookMainWakeup;
          if Assigned(Workers) and (not Workers.Terminating) then
          // CPU ռ�õ��� 60% ʱ�Ŵ�����Щ����Ҫ����
          begin
            CheckPlans;
            if LastCpuUsage < 60 then
            begin
              if Assigned(Workers.FSimpleJobs) and
                (Workers.FSimpleJobs.Count > 0) and (Workers.IdleWorkers = 0)
              then
                Workers.LookupIdleWorker(true);
              if (Workers.JobFrozenTime <> INFINITE) and
                Assigned(Workers.OnJobFrozen) then
                CheckFrozenJobs;
            end;
          end;
        end;
    end;
  end;
  if Assigned(Workers) and (not Workers.Terminating) then
    Workers.FStaticThread := nil;
end;

{ TQJobExtData }

constructor TQJobExtData.Create(AData: Pointer; AOnFree: TQExtFreeEvent);
begin
  inherited Create;
  FOrigin := AData;
  FOnFree := AOnFree;
end;

constructor TQJobExtData.Create(const S: QStringW);
var
  D: PQStringW;
begin
  New(D);
  D^ := S;
  Create(D, DoFreeAsString);
end;
{$IFNDEF NEXTGEN}

constructor TQJobExtData.Create(const S: AnsiString);
var
  D: PAnsiString;
begin
  New(D);
  D^ := S;
  Create(D, DoFreeAsAnsiString);
end;
{$ENDIF}

constructor TQJobExtData.Create(const AParams: array of const);
var
  T: PVariant;
  I: Integer;
begin
  New(T);
  T^ := VarArrayCreate([0, High(AParams)], varVariant);
  for I := 0 to High(AParams) do
  begin
    case AParams[I].VType of
      vtBoolean:
        T^[I] := AParams[I].VBoolean;
      vtObject:
        T^[I] := IntPtr(AParams[I].VObject);
      vtClass:
        T^[I] := IntPtr(AParams[I].VClass);
      vtInterface:
        T^[I] := IUnknown(AParams[I].VInterface);
      vtInteger:
        T^[I] := AParams[I].VInteger;
{$IFNDEF NEXTGEN}
      vtChar:
        T^[I] := AParams[I].VChar;
{$ENDIF !NEXTGEN}
      vtWideChar:
        T^[I] := AParams[I].VWideChar;
      vtExtended:
        T^[I] := AParams[I].VExtended^;
      vtCurrency:
        T^[I] := AParams[I].VCurrency^;
      vtPointer:
        T^[I] := IntPtr(AParams[I].VPointer);
{$IFNDEF NEXTGEN}
      vtPChar:
        T^[I] := AnsiString(AParams[I].VPChar);
{$ENDIF !NEXTGEN}
      vtPWideChar:
        // 2009֮ǰû��UnicodeString
        T^[I] := {$IF RTLVersion<20}WideString{$ELSE}UnicodeString{$IFEND}(AParams[I].VPWideChar);
{$IFNDEF NEXTGEN}
      vtString:
        T^[I] := AParams[I].VString^;
      vtAnsiString:
        T^[I] := AnsiString(AParams[I].VAnsiString);
      vtWideString:
        T^[I] := WideString(AParams[I].VWideString);
{$ENDIF !NEXTGEN}
      vtVariant:
        T^[I] := AParams[I].VVariant^;
      vtInt64:
        T^[I] := AParams[I].VInt64^;
{$IF RTLVersion>=20}
      vtUnicodeString:
        T^[I] := UnicodeString(AParams[I].VUnicodeString);
{$IFEND >=2009}
    end;
  end;
  Create(T, DoFreeAsVariant);
end;

constructor TQJobExtData.Create(const APlan: TQPlanMask; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  APlanData: PQJobPlanData;
begin
  New(APlanData);
  APlanData.OriginData := AData;
  APlanData.Plan := APlan;
  APlanData.DataFreeType := AFreeType;
  APlanData.Runnings := 0;
  APlanData.Plan.Timeout(Now);
  if AData <> nil then
  begin
    if AFreeType = jdfFreeAsInterface then
      (IInterface(AData) as IInterface)._AddRef
    else if AFreeType = jdfFreeAsParams then
      IQJobNamedParams(AData)._AddRef
{$IFDEF NEXTGEN}
      // �ƶ�ƽ̨��AData�ļ�����Ҫ���ӣ��Ա����Զ��ͷ�
    else if AFreeType = jdfFreeAsObject then
      TObject(AData).__ObjAddRef;
{$ENDIF};
  end;
  Create(APlanData, DoFreeAsPlan);
end;

constructor TQJobExtData.Create(const Value: Integer);
begin
  FOrigin := Pointer(Value);
  inherited Create;
end;

constructor TQJobExtData.Create(const Value: Int64);
{$IFDEF CPUX64}
begin
  FOrigin := Pointer(Value);
  inherited Create;
{$ELSE}
var
  D: PInt64;
begin
  GetMem(D, SizeOf(Int64));
  D^ := Value;
  Create(D, DoSimpleTypeFree);
{$ENDIF}
end;

constructor TQJobExtData.Create(const Value: Boolean);
begin
  FOrigin := Pointer(Integer(Value));
  inherited Create;
end;

constructor TQJobExtData.Create(const Value: Double);
var
  D: PDouble;
begin
  GetMem(D, SizeOf(Double));
  D^ := Value;
  Create(D, DoSimpleTypeFree);
end;

constructor TQJobExtData.CreateAsDateTime(const Value: TDateTime);
begin
  Create(Value);
end;

{$IFDEF UNICODE}

constructor TQJobExtData.Create(AOnInit: TQExtInitEventA;
  AOnFree: TQExtFreeEventA);
begin
  FOnFreeA := AOnFree;
  if Assigned(AOnInit) then
    AOnInit(FOrigin);
  inherited Create;
end;
{$ENDIF}

constructor TQJobExtData.Create(AOnInit: TQExtInitEvent;
  AOnFree: TQExtFreeEvent);
begin
  FOnFree := AOnFree;
  if Assigned(AOnInit) then
    AOnInit(FOrigin);
  inherited Create;
end;

{$IFDEF UNICODE}

constructor TQJobExtData.Create(AData: Pointer; AOnFree: TQExtFreeEventA);
begin
  inherited Create;
  FOrigin := AData;
  FOnFreeA := AOnFree;
end;
{$ENDIF}

destructor TQJobExtData.Destroy;
begin
  if Assigned(Origin) then
  begin
{$IFDEF UNICODE}
    if Assigned(FOnFreeA) then
      FOnFreeA(Origin);
{$ENDIF}
    if Assigned(FOnFree) then
      FOnFree(Origin);
  end;
  inherited;
end;
{$IFNDEF NEXTGEN}

procedure TQJobExtData.DoFreeAsAnsiString(AData: Pointer);
begin
  Dispose(PAnsiString(AData));
end;
{$ENDIF}

procedure TQJobExtData.DoFreeAsVariant(AData: Pointer);
var
  pVar: PVariant;
begin
  pVar := AData;
  Dispose(pVar);
end;

procedure TQJobExtData.DoFreeAsPlan(AData: Pointer);
var
  APlan: PQJobPlanData;
begin
  APlan := AData;
  if APlan.OriginData <> nil then
    Workers.FreeJobData(APlan.OriginData, APlan.DataFreeType);
  Dispose(PQJobPlanData(AData));
end;

procedure TQJobExtData.DoFreeAsString(AData: Pointer);
begin
  Dispose(PQStringW(AData));
end;

procedure TQJobExtData.DoSimpleTypeFree(AData: Pointer);
begin
  FreeMem(AData);
end;
{$IFNDEF NEXTGEN}

function TQJobExtData.GetAsAnsiString: AnsiString;
begin
  Result := PAnsiString(Origin)^;
end;
{$ENDIF}

function TQJobExtData.GetAsBoolean: Boolean;
begin
  Result := Origin <> nil;
end;

function TQJobExtData.GetAsDateTime: TDateTime;
begin
  Result := PDateTime(Origin)^;
end;

function TQJobExtData.GetAsDouble: Double;
begin
  Result := PDouble(Origin)^;
end;

function TQJobExtData.GetAsInt64: Int64;
begin
  Result := PInt64(Origin)^;
end;

function TQJobExtData.GetAsInteger: Integer;
begin
  Result := Integer(Origin);
end;

function TQJobExtData.GetAsPlan: PQJobPlanData;
begin
  Result := Origin;
end;

function TQJobExtData.GetAsString: QStringW;
  function IsFreeBy(AFreeMethod: TQExtFreeEvent): Boolean;
  begin
    Result := MethodEqual(TMethod(FOnFree), TMethod(AFreeMethod));
  end;

begin
  if IsFreeBy(DoFreeAsString) then
    Result := PQStringW(Origin)^
{$IFNDEF NEXTGEN}
  else if IsFreeBy(DoFreeAsAnsiString) then
    Result := QStringW(AsAnsiString)
{$ENDIF}
  else if IsFreeBy(DoFreeAsPlan) then
    Result := AsPlan.Plan.AsString
  else
    Result := '';
end;

function TQJobExtData.GetParamCount: Integer;
begin
  Result := VarArrayHighBound(PVariant(FOrigin)^, 1) + 1;
end;

function TQJobExtData.GetParams(AIndex: Integer): Variant;
begin
  Result := PVariant(FOrigin)^[AIndex];
end;

{$IFNDEF NEXTGEN}

procedure TQJobExtData.SetAsAnsiString(const Value: AnsiString);
begin
  PAnsiString(Origin)^ := Value;
end;
{$ENDIF}

procedure TQJobExtData.SetAsBoolean(const Value: Boolean);
begin
  FOrigin := Pointer(Integer(Value));
end;

procedure TQJobExtData.SetAsDateTime(const Value: TDateTime);
begin
  PDateTime(Origin)^ := Value;
end;

procedure TQJobExtData.SetAsDouble(const Value: Double);
begin
  PDouble(Origin)^ := Value;
end;

procedure TQJobExtData.SetAsInt64(const Value: Int64);
begin
{$IFDEF CPUX64}
  FOrigin := Pointer(Value);
{$ELSE}
  PInt64(FOrigin)^ := Value;
{$ENDIF}
end;

procedure TQJobExtData.SetAsInteger(const Value: Integer);
begin
  FOrigin := Pointer(Value);
end;

procedure TQJobExtData.SetAsString(const Value: QStringW);
begin
  PQStringW(FOrigin)^ := Value;
end;

procedure RunInMainThread(AProc: TMainThreadProc; AData: Pointer); overload;
var
  AHelper: TRunInMainThreadHelper;
begin
  AHelper := TRunInMainThreadHelper.Create;
  AHelper.FProc := AProc;
  AHelper.FData := AData;
  try
    TThread.Synchronize(nil, AHelper.Execute);
  finally
    FreeObject(AHelper);
  end;
end;

procedure RunInMainThread(AProc: TMainThreadProcG; AData: Pointer); overload;
var
  AHelper: TRunInMainThreadHelper;
begin
  AHelper := TRunInMainThreadHelper.Create;
  TMethod(AHelper.FProc).Code := @AProc;
  TMethod(AHelper.FProc).Data := nil;
  AHelper.FData := AData;
  try
    TThread.Synchronize(nil, AHelper.Execute);
  finally
    FreeObject(AHelper);
  end;
end;
{$IFDEF UNICODE}

procedure RunInMainThread(AProc: TThreadProcedure); overload;
begin
  TThread.Synchronize(nil, AProc);
end;
{$ENDIF}
{ TRunInMainThreadHelper }

procedure TRunInMainThreadHelper.Execute;
begin
  if TMethod(FProc).Data = nil then
    TMainThreadProcG(TMethod(FProc).Code)(FData)
  else
    FProc(FData);
end;

{ TQSignalQueue }

procedure TQSignalQueue.Clear;
var
  ANext: PQSignalQueueItem;
begin
  FLocker.Enter;
  try
    while Assigned(FFirst) do
    begin
      if Assigned(FFirst.WaitEvent) then
        TEvent(FFirst.WaitEvent).SetEvent;
      ANext := FFirst.Next;
      Dispose(FFirst);
      FFirst := ANext;
    end;
    FLast := nil;
    FCount := 0;
  finally
    FLocker.Leave;
  end;
end;

constructor TQSignalQueue.Create(AOwner: TQWorkers);
begin
  inherited Create;
  FLocker := TQSimpleLock.Create;
  FOwner := AOwner;
  FMaxItems := 4096;
end;

destructor TQSignalQueue.Destroy;
begin
  Clear;
  FreeAndNil(FLocker);
  inherited;
end;

procedure TQSignalQueue.FireNext;
begin
  FLocker.Enter;
  try
    if Assigned(FLastPop) then
      Exit;
    FLastPop := FFirst;
    if Assigned(FFirst) then
      FFirst := FFirst.Next;
    if not Assigned(FFirst) then
      FLast := nil;
    if Assigned(FLastPop) then
      Dec(FCount);
  finally
    FLocker.Leave;
  end;
  if Assigned(FLastPop) then
    FOwner.FireSignalJob(FLastPop);
end;

procedure TQSignalQueue.FreeItem(AItem: PQSignalQueueItem);
begin
  if Assigned(AItem.Data) and (AItem.FreeType <> jdfFreeByUser) then
    FOwner.FreeJobData(AItem.Data, AItem.FreeType);
  Dispose(AItem);
end;

function TQSignalQueue.InternalPost(AItem: PQSignalQueueItem): Boolean;
var
  ADoFire: Boolean;
begin
  Result := Count < MaxItems;
  if Result then
  begin
    FLocker.Enter;
    if Assigned(FLast) then
      FLast.Next := AItem
    else
      FFirst := AItem;
    FLast := AItem;
    ADoFire := FFirst = FLast;
    Inc(FCount);
    FLocker.Leave;
    if ADoFire then
      FireNext;
  end
  else
    FreeItem(AItem);
end;

function TQSignalQueue.NewItem(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType; AWaiter: TEvent): PQSignalQueueItem;
begin
  New(Result);
  Result.Id := AId;
  Result.FreeType := AFreeType;
  Result.Data := AData;
  Result.FireCount := 0;
  Result.RefCount := 0;
  if Assigned(AData) then
  begin
    if AFreeType = jdfFreeAsInterface then
      (IInterface(AData) as IInterface)._AddRef
    else if AFreeType = jdfFreeAsParams then
      IQJobNamedParams(AData)._AddRef
{$IFDEF AUTOREFCOUNT}
    else if AFreeType = jdfFreeAsObject then
      TObject(AData).__ObjAddRef
{$ENDIF}
        ;
  end;
  Result.Next := nil;
  Result.WaitEvent := AWaiter;
{$IFDEF AUTOREFCOUNT}
  if Assigned(AWaiter) then
    AWaiter.__ObjAddRef;
{$ENDIF}
end;

function TQSignalQueue.Post(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType): Boolean;
begin
  Result := InternalPost(NewItem(AId, AData, AFreeType, nil));
end;

function TQSignalQueue.Post(AName: QStringW; AData: Pointer;
  AFreeType: TQJobDataFreeType): Boolean;
begin
  Result := InternalPost(NewItem(FOwner.RegisterSignal(AName), AData,
    AFreeType, nil));
end;

function TQSignalQueue.Send(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType; ATimeout: Cardinal): TWaitResult;
var
  AItem: PQSignalQueueItem;
  AEvent: TEvent;
begin
  if ATimeout = 0 then
    AEvent := nil
  else
    AEvent := TEvent.Create(nil, false, false, '');
  AItem := NewItem(AId, AData, AFreeType, AEvent);
  Inc(AItem.RefCount);
  FOwner.FireSignalJob(AItem);
  if Assigned(AEvent) then
  begin
    Result := MsgWaitForEvent(AEvent, ATimeout);
    AtomicExchange(AItem.WaitEvent, nil); // �ÿ�
    FreeAndNil(AEvent);
  end
  else
    Result := wrSignaled;
  if AtomicDecrement(AItem.RefCount) = 0 then
    FreeItem(AItem);
end;

function TQSignalQueue.Send(AName: QStringW; AData: Pointer;
  AFreeType: TQJobDataFreeType; ATimeout: Cardinal): TWaitResult;
begin
  Result := Send(FOwner.RegisterSignal(AName), AData, AFreeType, ATimeout);
end;

procedure TQSignalQueue.SingalJobDone(AItem: PQSignalQueueItem);
begin
  if Assigned(AItem.WaitEvent) then
    TEvent(AItem.WaitEvent).SetEvent;
  if AtomicDecrement(AItem.RefCount) = 0 then
    FreeItem(AItem);
  if AItem = FLastPop then
  begin
    FLastPop := nil;
    FireNext;
  end;
end;

{ TQRunonceTask }
{$IFDEF UNICODE}

procedure TQRunonceTask.Runonce(ACallback: TProc);
begin
  while CanRun = 1 do
  begin
    if AtomicCmpExchange(CanRun, 0, 1) = 1 then
      ACallback;
  end;
end;
{$ENDIF}

procedure TQRunonceTask.Runonce(ACallback: TProcedure);
begin
  while CanRun = 1 do
  begin
    if AtomicCmpExchange(CanRun, 0, 1) = 1 then
      ACallback;
  end;
end;

procedure TQRunonceTask.Runonce(ACallback: TThreadMethod);
begin
  while CanRun = 1 do
  begin
    if AtomicCmpExchange(CanRun, 0, 1) = 1 then
      ACallback;
  end;
end;

{ TQWorkerExt }

constructor TQWorkerExt.Create(AOwner: TQWorker);
begin
  inherited Create;
  FOwner := AOwner;
end;

{ TQJobParams }

constructor TQJobParams.Create(const AParams: array of TQJobParamPair);
var
  I: Integer;
begin
  inherited Create;
  SetLength(FParams, Length(AParams));
  for I := 0 to High(AParams) do
    FParams[I] := AParams[I];
end;

function TQJobParams.GetCount: Integer;
begin
  Result := Length(FParams);
end;

function TQJobParams.GetParam(const AIndex: Integer): PQJobParamPair;
begin
  Result := @FParams[AIndex];
end;

function TQJobParams.ValueByName(const AName: String): Variant;
var
  I: Integer;
begin
  for I := 0 to High(FParams) do
  begin
    if CompareText(FParams[I].Name, AName) = 0 then
    begin
      Result := FParams[I].Value;
      Break;
    end;
  end;
end;

procedure RegisterSyncEntry(const AProc: Pointer); stdcall; forward;
procedure UnregisterSyncEntry(const AProc: Pointer); stdcall; forward;

procedure Startup;
begin
  TAbortableEvent.First := nil;
  TAbortableEvent.Last := nil;
  AddTerminateProc(DoAppTerminate);
  if not Assigned(Workers) then
  begin
    GetThreadStackInfo := nil;
    AppTerminated := false;
{$IFDEF MSWINDOWS}
    GetTickCount64 := GetProcAddress(GetModuleHandle(kernel32),
      'GetTickCount64');
    WinGetSystemTimes := GetProcAddress(GetModuleHandle(kernel32),
      'GetSystemTimes');
    OpenThread := GetProcAddress(GetModuleHandle(kernel32), 'OpenThread');
    if not QueryPerformanceFrequency(_PerfFreq) then
    begin
      _PerfFreq := -1;
      if Assigned(GetTickCount64) then
        _StartCounter := GetTickCount64
      else
        _StartCounter := GetTickCount;
    end
    else
      QueryPerformanceCounter(_StartCounter);
{$ELSE}
    _Watch := TStopWatch.Create;
    _Watch.Start;
{$ENDIF}
    _CPUCount := GetCPUCount;
    JobPool := TJobPool.Create(1024);
    Workers := TQWorkers.Create;
    if IsLibrary then
      RegisterSyncEntry(@CheckSynchronize);
  end;
end;

procedure Cleanup;
begin
  if IsLibrary then
    UnregisterSyncEntry(@CheckSynchronize);
  if Assigned(TDLLMainThreadSyncHelper.FCurrent) then
    FreeAndNil(TDLLMainThreadSyncHelper.FCurrent);
{$IFDEF AUTOREFCOUNT}
  Workers.DisposeOf;
{$ELSE}
  Workers.Free;
{$ENDIF}
  Workers := nil;
  FreeAndNil(JobPool);
end;

procedure RegisterSyncEntry(const AProc: Pointer); stdcall; export;
begin
  if Assigned(TDLLMainThreadSyncHelper.Current.HostRegister) then
    TDLLMainThreadSyncHelper.Current.HostRegister(AProc);
end;

procedure UnregisterSyncEntry(const AProc: Pointer); stdcall; export;
begin
  if Assigned(TDLLMainThreadSyncHelper.FCurrent) and
    Assigned(TDLLMainThreadSyncHelper.FCurrent.HostUnregister) then
    TDLLMainThreadSyncHelper.Current.HostUnregister(AProc);
end;

{ TDLLMainThreadSyncHelper }

constructor TDLLMainThreadSyncHelper.Create;
begin
  if MainInstance <> HInstance then
  begin
    HostRegister := TSyncEntryRegister(GetProcAddress(MainInstance,
      'RegisterSyncEntry'));
    HostUnregister := TSyncEntryRegister(GetProcAddress(MainInstance,
      'UnregisterSyncEntry'));
    if not(Assigned(HostRegister) and Assigned(HostUnregister)) and
      (not Assigned(WakeMainThread)) then
    begin
{$IFDEF MSWINDOWS}
      DebugOut('[��ʾ]������δ���� QWorker����Ϊʹ���Զ��崰�ڴ���');
      FSyncWnd := AllocateHWND(DoSyncWndProc);
      FMainThreadWakeup := WakeMainThread;
      WakeMainThread := DoMainThreadWakeup;
      DebugOut('DLL:WakeMainThread %x', [IntPtr(@WakeMainThread)]);
{$ELSE}
      raise Exception.Create('[��ʾ]������δ���� QWorker���޷�ͬ�� WakeMainThread');
{$ENDIF}
    end;
  end
  else
  begin
    HostRegister := DoRegister;
    HostUnregister := DoUnregister;
  end;
end;

destructor TDLLMainThreadSyncHelper.Destroy;
begin
  WakeMainThread := FMainThreadWakeup;
{$IFDEF MSWINDOWS}
  if FSyncWnd <> 0 then
    DeallocateHWND(FSyncWnd);
{$ENDIF}
  if Assigned(FTimer) then
  begin
{$IFDEF MSWINDOWS}
    if IntPtr(FTimer) < $FFFF then
      KillTimer(0, IntPtr(FTimer))
    else
      FreeAndNil(FTimer);
{$ELSE}
    FreeAndNil(FTimer);
{$ENDIF}
  end;
  inherited;
end;
{$IFDEF MSWINDOWS}

procedure DoTimerSync(wnd: HWND; nMsg, nTimerid, dwTime: DWORD); stdcall;
begin
  TDLLMainThreadSyncHelper.Current.DoMainThreadWakeup(nil);
end;
{$ENDIF}

class destructor TDLLMainThreadSyncHelper.Destroy;
begin
  if Assigned(FCurrent) then
    FreeAndNil(FCurrent);
end;

procedure TDLLMainThreadSyncHelper.DLLSynchronize;
var
  I, J: Integer;
  ATemp: array of Pointer;
  APackNeeded: Boolean;
begin
  if Length(FDLLSyncEntries) > 0 then
  begin
    Workers.FLocker.Enter;
    try
      SetLength(ATemp, Length(FDLLSyncEntries));
      Move(FDLLSyncEntries[0], ATemp[0], SizeOf(Pointer) *
        Length(FDLLSyncEntries));
    finally
      Workers.FLocker.Leave;
    end;
    // �˺������ڱ�֤DLL �� QWorker ���߳��ܹ�����ִ��
    APackNeeded := false;
    for I := 0 to High(ATemp) do
    begin
      if Assigned(ATemp[I]) then
        TCheckSyncProc(ATemp[I])(0)
      else
        APackNeeded := true;
    end;
    if APackNeeded then
    begin
      // �пհ׵�ָ�룬����Ҫ����
      Workers.FLocker.Enter;
      try
        J := 0;
        for I := 0 to High(FDLLSyncEntries) do
        begin
          if Assigned(FDLLSyncEntries[I]) and (I <> J) then
          begin
            FDLLSyncEntries[J] := FDLLSyncEntries[I];
            Inc(J);
          end;
        end;
        SetLength(FDLLSyncEntries, J);
      finally
        Workers.FLocker.Leave;
      end;
    end;
  end;
end;

procedure TDLLMainThreadSyncHelper.DoMainThreadWakeup(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  if FSyncWnd <> 0 then
  begin
    PostMessage(FSyncWnd, WM_NULL, 0, 0);
    Exit;
  end;
{$ENDIF}
  if Length(FDLLSyncEntries) > 0 then
  begin
    if (AtomicExchange(FWakeupFlags, 1) = 0) then
    begin
      if not IsLibrary then
        TThread.Queue(nil, DLLSynchronize);
      if Assigned(FMainThreadWakeup) then
        FMainThreadWakeup(Self);
      AtomicExchange(FWakeupFlags, 0);
    end;
  end
  else if Assigned(FMainThreadWakeup) then
    FMainThreadWakeup(Self);
end;

class procedure TDLLMainThreadSyncHelper.DoRegister(const AProc: Pointer);
begin
  Workers.FLocker.Enter;
  try
    SetLength(Current.FDLLSyncEntries, Length(Current.FDLLSyncEntries) + 1);
    Current.FDLLSyncEntries[High(Current.FDLLSyncEntries)] := @AProc;
  finally
    Workers.FLocker.Leave;
  end;
end;
{$IFDEF MSWINDOWS}

procedure TDLLMainThreadSyncHelper.DoSyncWndProc(var AMsg: TMessage);
begin
  if AMsg.MSG = WM_NULL then
    CheckSynchronize
  else
    AMsg.Result := DefWindowProc(FSyncWnd, AMsg.MSG, AMsg.WParam, AMsg.LParam);
end;
{$ENDIF}

class procedure TDLLMainThreadSyncHelper.DoUnregister(const AProc: Pointer);
var
  I: Integer;
begin
  // ��ȥɾ����
  Workers.FLocker.Enter;
  try
    for I := High(Current.FDLLSyncEntries) downto 0 do
    begin
      if Current.FDLLSyncEntries[I] = AProc then
        Current.FDLLSyncEntries[I] := nil;
    end;
  finally
    Workers.FLocker.Leave;
  end;
end;

class function TDLLMainThreadSyncHelper.GetCurrent: TDLLMainThreadSyncHelper;
begin
  if not Assigned(FCurrent) then
    FCurrent := TDLLMainThreadSyncHelper.Create;
  Result := FCurrent;
end;

procedure TDLLMainThreadSyncHelper.HookMainWakeup;
  function Hooked(ACurrent, ATarget: TNotifyEvent): Boolean;
  begin
    Result := (TMethod(ACurrent).Code = TMethod(ATarget).Code) and
      (TMethod(ACurrent).Data = TMethod(ATarget).Data);
  end;

begin
  if (not Workers.Terminating) and Assigned(WakeMainThread) and
    (not Hooked(DoMainThreadWakeup, WakeMainThread)) then
  begin
    Workers.FLocker.Enter;
    try
      if not Hooked(DoMainThreadWakeup, WakeMainThread) then
      begin
        FMainThreadWakeup := WakeMainThread;
        WakeMainThread := DoMainThreadWakeup;
      end;
    finally
      Workers.FLocker.Leave;
    end;
  end;
end;
{$IFNDEF DISABLE_HOST_EXPORTS}
exports RegisterSyncEntry, UnregisterSyncEntry;
{$ENDIF}
{ TAbortableEvent }

class procedure TAbortableEvent.AbortAll;
var
  AItem, ANext: PAbortableEvent;
begin
  GlobalNameSpace.BeginWrite;
  try
    AItem := TAbortableEvent.First;
    TAbortableEvent.First := nil;
    TAbortableEvent.Last := nil;
    while Assigned(AItem) do
    begin
      ANext := AItem.Next;
      AItem.AbortWait;
      if Assigned(ANext) then
        ANext.Prior := nil;
      AItem := ANext;
    end;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

procedure TAbortableEvent.AbortWait;
begin
  Aborted := true;
  Event.SetEvent;
end;

procedure TAbortableEvent.InsertWait(AEvent: TEvent);
begin
  Event := AEvent;
  Aborted := false;
  Next := nil;
  GlobalNameSpace.BeginWrite;
  try
    Prior := TAbortableEvent.Last;
    if Assigned(TAbortableEvent.Last) then
      TAbortableEvent.Last.Next := @Self;
    if not Assigned(TAbortableEvent.First) then
      TAbortableEvent.First := @Self;
    TAbortableEvent.Last := @Self;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

procedure TAbortableEvent.RemoveWait;
var
  APrior, ANext: PAbortableEvent;
begin
  GlobalNameSpace.BeginWrite;
  try
    APrior := Prior;
    ANext := Next;
    if TAbortableEvent.Last = @Self then
      TAbortableEvent.Last := APrior;
    if TAbortableEvent.First = @Self then
      TAbortableEvent.First := ANext;
    if Assigned(APrior) then
      APrior.Next := ANext;
    if Assigned(ANext) then
      ANext.Prior := APrior;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

function TAbortableEvent.WaitFor(AEvent: TEvent; const ATimeout: Cardinal)
  : TWaitResult;
begin
  InsertWait(AEvent);
  try
    if not AppTerminated then
    begin
      Result := AEvent.WaitFor(ATimeout);
      if Aborted and (Result = wrSignaled) then
        Result := wrAbandoned;
    end
    else
      Result := wrAbandoned;
  finally
    RemoveWait;
  end;
end;

initialization

Startup;

finalization

Cleanup;

end.
