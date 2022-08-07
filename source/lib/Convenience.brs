function ObjectInitialized(object as dynamic) as Boolean
  if Type(object) <> "Invalid" and Type(object) <> "<uninitialized>"
    return True
  else
    return False
  end if
end function