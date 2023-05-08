package com.dongguk.cse.naemansan.service;

import com.dongguk.cse.naemansan.domain.*;
import com.dongguk.cse.naemansan.dto.UserDto;
import com.dongguk.cse.naemansan.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final ImageRepository imageRepository;
    private final LikeRepository likeRepository;
    private final CommentRepository commentRepository;
    private final BadgeRepository badgeRepository;
    private final FollowRepository followRepository;
    private final SubscribeRepository subscribeRepository;

    public UserDto getUserInformation(Long id) {
        log.info("Get UserInformation - ID : {}", id);

        Optional<User> user = userRepository.findById(id);
        Optional<Image> image = imageRepository.findByUserId(id);
        List<Like> likes = likeRepository.findByUserId(id);
        List<Comment> comments = commentRepository.findByUserId(id);
        List<Badge> badges = badgeRepository.findByUserId(id);
        List<Follow> followings = followRepository.findByFollowingId(id);
        List<Follow> followers = followRepository.findByFollowedId(id);
        Optional<Subscribe> subscribe = subscribeRepository.findByUserId(id);


        UserDto userDto = null;
        try {
            if (user.isEmpty() || image.isEmpty() || likes == null || comments == null || badges == null
            || followings == null || followers == null)
                throw new NullPointerException();
            else
                userDto = UserDto.builder()
                        .user(user.get())
                        .image(image.get())
                        .isPremium(subscribe.isEmpty() ? false : true)
                        .commentCnt((long) comments.size())
                        .likeCnt((long) likes.size())
                        .badgeCnt((long) badges.size())
                        .followingCnt((long) followings.size())
                        .followerCnt((long) followers.size())
                        .build();
        } catch (Exception e) {
            log.info("{}", e);
        }

        return userDto;
    }
}