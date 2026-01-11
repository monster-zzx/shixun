package com.bar.mapper;
import com.bar.beans.User;

import java.util.List;
public interface UserMapper {
    List<User> list();
    User selectUser(Integer id);
}
