import React from 'react'
import { Student } from '../Discussion'
import { Avatar } from '../../common/Avatar'
import { FavoriteButton } from './FavoriteButton'

export const StudentInfo = ({ student }: { student: Student }): JSX.Element => {
  return (
    <div className="student-info">
      {student.handle}

      {student.name}
      {student.bio}
      {student.languagesSpoken.join(', ')}
      {student.reputation}
      <Avatar src={student.avatarUrl} handle={student.handle} />
      <FavoriteButton
        isFavorite={student.isFavorite}
        endpoint={student.links.favorite}
      />
    </div>
  )
}
