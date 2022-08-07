function SendRequest(link as String, headers = {}, rtype = "get") as String
  request = CreateObject("roUrlTransfer")

  request.SetCertificatesFile("common:/certs/ca-bundle.crt")
  if headers.Count() <> 0
    for each header in headers
      request.AddHeader(header, headers.Lookup(header))
    end for
  end if
  request.EnableEncodings(true)
  request.InitClientCertificates()

  request.SetUrl(link)

  if rtype <> "get"
    request.SetRequest(rtype)
  end if

  m.bg_service.AddTask("", request, rtype)
  return "task" + IToStr(request.GetIdentity())
end function

function SendFileRequest(link as String, fn, headers = {}) as String
  request = CreateObject("roUrlTransfer")

  request.SetCertificatesFile("common:/certs/ca-bundle.crt")
  if headers.Count() <> 0
    for each header in headers
      request.AddHeader(header, headers.Lookup(header))
    end for
  end if
  request.EnableEncodings(true)
  request.InitClientCertificates()

  request.SetUrl(link)

  m.bg_service.AddTask("", request, "get", fn)
  return "task" + IToStr(request.GetIdentity())
end function

function GetStringParam(params as Object) as String
  paramString = ""

  param   = []
  val   = []

  for each key in params
    if params[key] <> ""
      param.Push(key)
      val.Push(AnyToString(params[key]))
    end if
  end for

  ' & = ASCII 38
  ' = = ASCII 61
  ' ? = ASCII 63

  paramString = Chr(63) + param[0] + Chr(61) + val[0]

  if param.Count() > 1
    for count = 1 to param.Count() - 1
      paramString = paramString + Chr(38) + param[count] + Chr(61) + val[count]
    end for
  end if

  urlEncoder = CreateObject("roUrlTransfer")
  paramString = urlEncoder.Escape(paramString)

  return paramString
end function

function BGHTTPService() as Object
  bgservice = {}

  bgservice.timer = CreateObject("roTimespan")
  bgservice.servicePort = CreateObject("roMessagePort")
  bgservice.timeOut = 5000
  bgservice.taskList = {}

  bgservice.taskList.count = 0

  bgservice.AddTask = function(pTask, pData, pType = "", pParam = "", pStart = 0, pStarted = False) as String
              taskName = ""

              if Type(pData) = "roUrlTransfer"
                if ObjectInitialized(pData.GetPort()) = False
                  pData.SetPort(m.GetPort())
                end if

                if Type(pTask) = "String" and Len(pTask) <> 0
                  taskName = pTask
                else
                  taskName = "task" + IToStr(pData.GetIdentity())
                end if

                if m.TaskExists(taskName) = False
                  m.taskList.count = m.taskList.count + 1
                end if

                newData = {}

                newData.o = pData
                newData.dType = pType
                newData.param = pParam
                newData.start = pStart
                newData.started = pStarted
                newData.rData = { served : False, received : False, response : "" }

                m.taskList.AddReplace(taskName, newData)
              end if

              return taskName
            end function

  bgservice.TaskExists =  function(taskName) as Boolean
                return m.taskList.DoesExist(taskName)
              end function

  bgservice.GetTask = function(taskName) as Object
              return m.taskList.Lookup(taskName)
            end function

  bgservice.GetTaskStatus =   function(taskName) as Boolean
                  tStatus = m.GetTask(taskName)
                  return tStatus.rData.served
                end function

  bgservice.SetTaskFlag = function(taskname, nStatus) as Void
                tFlag = m.GetTask(taskName)
                flagSet = tFlag.rData

                flagSet.received = nStatus

                tFlag.AddReplace("rdata", flagSet)
                m.taskList.AddReplace(taskName, tFlag)
              end function

  bgservice.SeeTask = function(taskName) as Void
              PrintAA(m.GetTask(taskName))
            end function

  bgservice.DelTask = function(taskName) as Void
              ender = m.GetTask(taskName)
              ender.o.AsyncCancel()
              m.taskList.Delete(taskName)
              m.taskList.count = m.taskList.count - 1
            end function

  bgservice.ListTasks =   function() as Void
                PrintAA(m.taskList)
              end function

  bgservice.TaskCount =   function() as Void
                print m.taskList.count
              end function

  bgservice.ClearTasks =  function() as Void
                for each key in m.taskList
                  if Type(m.taskList[key]) = "roAssociativeArray"
                    m.DelTask(key)
                  end if
                end for
              end function

  bgservice.StartTask =   function(taskName, bgType = "get") as Void
                starter = m.GetTask(taskName)

                if starter.dType = "post" and Len(starter.param) <> 0
                  starter.o.AsyncPostFromString(ValidStr(starter.param))
                else if starter.dtype = "get"
                  starter.o.AsyncGetToString()
                end if

                if starter.started = False
                  m.AddTask(taskName, starter.o, starter.dType, starter.param, m.timer.TotalMilliseconds(), True)
                end if
              end function

  bgservice.StartFileTask =   function(taskName) as Void
                  starter = m.GetTask(taskName)

                  starter.o.AsyncGetToFile("tmp:/" + starter.param)

                  if starter.started = False
                    m.AddTask(taskName, starter.o, starter.dType, starter.param, m.timer.TotalMilliseconds(), True)
                  end if
                end function

  bgservice.GetPort = function() as Object
              return m.servicePort
            end function

  bgservice.GetTaskResponse = function(taskName) as String
                  ret = ""
                  task = m.GetTask(taskName)
                  response = task.rData

                  if response.served = True
                    ret = response.response
                  end if

                  return ret
                end function

  bgservice.SetTaskResponse = function(taskName, newResponse) as Void
                  if m.TaskExists(taskName) = True
                    task = m.GetTask(taskName)
                    response = task.rData

                    if response.served = False
                      response.served = True
                      response.response = newResponse

                      task.AddReplace("rData", response)
                      m.taskList.AddReplace(taskName, task)
                    end if
                  end if
                end function

  bgservice.CheckTasks =  function() as Dynamic
                  msg = ""
                  port = m.GetPort()

                  msg = port.GetMessage()

                  if msg <> invalid and type(msg) = "roUrlEvent"
                    code = msg.GetResponseCode()
                      taskName = "task" + IToStr(msg.GetSourceIdentity())
                    if code = 200
                      m.SetTaskResponse(taskName, msg.GetString())
                      return taskName
                    else
                      print msg.GetFailureReason()
                      m.SetTaskResponse(taskName, msg.GetString())
                    end if
                  end if

                  return invalid
              end function

  return bgservice
end function
